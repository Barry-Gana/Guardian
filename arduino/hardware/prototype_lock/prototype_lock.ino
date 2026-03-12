#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>

// ===== Prototype constants =====
#define WIFI_SSID "GANA-26"
#define WIFI_PASSWORD "GANA+2020"

#define FIREBASE_DATABASE_URL "https://guardian-prototype-7f143-default-rtdb.europe-west1.firebasedatabase.app"
#define DEVICE_ID "guardian-lock-001"

#define RELAY_PIN 26
#define RELAY_PULSE_MS 1000

// ===== Timing =====
unsigned long lastPresenceMs = 0;
unsigned long lastPollMs = 0;
const unsigned long PRESENCE_INTERVAL_MS = 5000;
const unsigned long POLL_INTERVAL_MS = 200;

// ===== Helpers =====
String basePath() {
  return String(FIREBASE_DATABASE_URL) + "/devices/" + DEVICE_ID;
}

void triggerRelayPulse() {
  Serial.println("Triggering relay...");
  digitalWrite(RELAY_PIN, HIGH);
  delay(RELAY_PULSE_MS);
  digitalWrite(RELAY_PIN, LOW);
  Serial.println("Relay closed.");
}

void connectToWiFi() {
  if (WiFi.status() == WL_CONNECTED) return;

  Serial.print("Connecting to Wi-Fi SSID: ");
  Serial.println(WIFI_SSID);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println();
  Serial.print("Connected to Wi-Fi! IP: ");
  Serial.println(WiFi.localIP());
}

bool httpGetString(const String& url, String& response) {
  WiFiClientSecure client;
  client.setInsecure();  // Prototype only

  HTTPClient https;
  if (!https.begin(client, url)) {
    Serial.println("HTTPS begin failed");
    return false;
  }

  int httpCode = https.GET();
  if (httpCode > 0) {
    response = https.getString();
    https.end();
    return true;
  } else {
    Serial.print("GET failed, code: ");
    Serial.println(httpCode);
    https.end();
    return false;
  }
}

bool httpPutJson(const String& url, const String& jsonBody) {
  WiFiClientSecure client;
  client.setInsecure();  // Prototype only

  HTTPClient https;
  if (!https.begin(client, url)) {
    Serial.println("HTTPS begin failed");
    return false;
  }

  https.addHeader("Content-Type", "application/json");
  int httpCode = https.PUT(jsonBody);

  if (httpCode <= 0) {
    Serial.print("PUT failed, code: ");
    Serial.println(httpCode);
    https.end();
    return false;
  }

  https.end();
  return true;
}

bool httpPatchJson(const String& url, const String& jsonBody) {
  WiFiClientSecure client;
  client.setInsecure();  // Prototype only

  HTTPClient https;
  if (!https.begin(client, url)) {
    Serial.println("HTTPS begin failed");
    return false;
  }

  https.addHeader("Content-Type", "application/json");
  int httpCode = https.sendRequest("PATCH", jsonBody);

  if (httpCode <= 0) {
    Serial.print("PATCH failed, code: ");
    Serial.println(httpCode);
    https.end();
    return false;
  }

  https.end();
  return true;
}

bool getCommand(String& command) {
  String response;
  String url = basePath() + "/command.json";

  if (!httpGetString(url, response)) return false;

  response.trim();
  // Response is JSON string like "lock" or "none"
  if (response.length() >= 2 && response[0] == '"' && response[response.length() - 1] == '"') {
    command = response.substring(1, response.length() - 1);
  } else {
    command = response;
  }
  return true;
}

bool getCommandId(String& commandId) {
  String response;
  String url = basePath() + "/commandId.json";

  if (!httpGetString(url, response)) return false;

  response.trim();
  if (response.length() >= 2 && response[0] == '"' && response[response.length() - 1] == '"') {
    commandId = response.substring(1, response.length() - 1);
  } else {
    commandId = response;
  }
  return true;
}

bool getUnlockBlocked(bool& blocked) {
  String response;
  String url = basePath() + "/unlockBlocked.json";

  if (!httpGetString(url, response)) return false;

  response.trim();
  blocked = (response == "true");
  return true;
}

void updatePresence() {
  String url = basePath() + ".json";
  String json =
    "{"
      "\"online\":true,"
      "\"lastSeen\":" + String(millis()) + ","
      "\"connectionMode\":\"internet\""
    "}";

  if (httpPatchJson(url, json)) {
    Serial.println("Presence updated.");
  }
}

void setStatusAndResult(const String& status, const String& commandId, const String& result) {
  String url = basePath() + ".json";
  String json =
    "{"
      "\"status\":\"" + status + "\","
      "\"lastCommandId\":\"" + commandId + "\","
      "\"lastActionResult\":\"" + result + "\""
    "}";

  httpPatchJson(url, json);
}

void resetCommand() {
  String url = basePath() + "/command.json";
  httpPutJson(url, "\"none\"");
}

void checkCommands() {
  String command;
  if (!getCommand(command)) return;

  if (command == "none" || command == "null" || command.length() == 0) {
    return;
  }

  String commandId = "";
  getCommandId(commandId);

  bool unlockBlocked = false;
  getUnlockBlocked(unlockBlocked);

  Serial.print("Received command: ");
  Serial.print(command);
  Serial.print(" [ID: ");
  Serial.print(commandId);
  Serial.println("]");

  if (command == "lock") {
    triggerRelayPulse();
    setStatusAndResult("locked", commandId, "success");
    resetCommand();
    Serial.println("Status updated to locked");
  } else if (command == "unlock") {
    if (!unlockBlocked) {
      triggerRelayPulse();
      setStatusAndResult("unlocked", commandId, "success");
      resetCommand();
      Serial.println("Status updated to unlocked");
    } else {
      setStatusAndResult("locked", commandId, "blocked");
      resetCommand();
      Serial.println("Unlock blocked by unlockBlocked flag");
    }
  } else {
    Serial.println("Unknown command, resetting to none");
    resetCommand();
  }
}

void setup() {
  Serial.begin(115200);

  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, LOW);

  connectToWiFi();
  updatePresence();
}

void loop() {
  connectToWiFi();

  unsigned long now = millis();

  if (now - lastPresenceMs >= PRESENCE_INTERVAL_MS || lastPresenceMs == 0) {
    lastPresenceMs = now;
    updatePresence();
  }

  if (now - lastPollMs >= POLL_INTERVAL_MS || lastPollMs == 0) {
    lastPollMs = now;
    checkCommands();
  }
}
