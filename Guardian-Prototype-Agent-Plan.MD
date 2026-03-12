# Guardian Smart Lock Prototype — Step-by-Step Implementation Plan for the AI Agent

## How to follow this plan

You are implementing a **one-device prototype** for the Guardian smart lock app.

You must work **step by step**.

### Execution rules

* Implement **only one step at a time**.
* After completing each step, **stop**.
* Then do **one of these before moving on**:

  * ask for my review, or
  * audit your own work and summarize what changed, what files were updated, and whether the step is complete.
* Do **not** continue to the next step automatically.
* Keep the prototype **simple**.
* Do **not** add extra architecture, extra features, or production-level complexity.
* Do **not** add authentication, multi-device support, schedules backend, scenes backend, automations backend, or AI control backend in this flow.
* Android only.
* Flutter app + Firebase Realtime Database + ESP32 Arduino code.

---

## Prototype constraints

These constraints apply to all steps:

* This is a **one-device prototype**.
* There is **only one lock** in the prototype.
* The lock ID is hardcoded as:

  * `guardian-lock-001`
* The database path is:

  * `devices/guardian-lock-001`
* The **Front Door** screen already exists.
* The Front Door screen already contains **one button** used to control the lock.
* That button **toggles lock/unlock**.
* Internet control must work **only when the Internet / Wi-Fi connection mode is enabled** in Settings.
* If Wi-Fi/Internet mode is OFF, the button must **not send any Firebase command**.
* If Wi-Fi/Internet mode is OFF, show this message:

  * `Internet control disabled. Enable Wi-Fi connection mode in Settings.`
* Keep the implementation simple and focused only on proving that one smart lock can be controlled over the internet.

---

## Shared prototype values

Use these exact values throughout the implementation.

### Lock

* `deviceId = guardian-lock-001`

### Firebase Realtime Database URL

* `https://guardian-prototype-7f143-default-rtdb.europe-west1.firebasedatabase.app/`

### ESP32 prototype values

* `WIFI_SSID = GANA-26`
* `WIFI_PASSWORD = GANA+2020`
* `RELAY_PIN = 26`
* `RELAY_PULSE_MS = 3000`

### Connection mode values

* `internet`
* `bluetooth`
* `local_wifi`

---

## Firebase data structure

Use this exact structure:

```json
{
  "devices": {
    "guardian-lock-001": {
      "command": "none",
      "commandId": "",
      "status": "locked",
      "online": false,
      "lastSeen": 0,
      "unlockBlocked": false,
      "connectionMode": "internet"
    }
  }
}
```

Later, this structure will be extended with:

```json
{
  "lastCommandId": "",
  "lastActionResult": ""
}
```

---

# Step 0 — Understand and confirm the prototype rules

## Goal

Confirm the implementation boundaries before writing or modifying code.

## What to do

* Read this full plan.
* Confirm that you understand the constraints.
* Confirm that the implementation is Android-only.
* Confirm that the prototype uses one hardcoded lock only.
* Confirm that internet control depends on the Settings connection mode being `internet`.

## Deliverable for this step

Provide a short summary of the rules you will follow.

## Stop condition

Stop after summarizing the rules. Do not change code yet.

---

# Step 1 — Define the shared Firebase model in code

## Goal

Create one shared source of truth for the database path and field names on the Flutter side.

## Requirements

Create constants for:

* database path: `devices/guardian-lock-001`
* field names:

  * `command`
  * `commandId`
  * `status`
  * `online`
  * `lastSeen`
  * `unlockBlocked`
  * `connectionMode`

Document the same structure clearly in comments so the ESP32 code can use the same naming later.

## Implementation notes

* Keep it simple.
* Do not add model classes unless needed.
* Prefer a small constants file or similar lightweight structure.

## Deliverable for this step

* Shared constants added on the Flutter side
* Clear documentation of the Firebase fields used by both Flutter and ESP32

## Stop condition

Stop after this step and report:

* files created/updated
* exact constants added
* confirmation that nothing else was changed

---

# Step 2 — Verify and complete Flutter Firebase setup

## Goal

Ensure the Flutter app is correctly configured for Firebase Realtime Database on Android.

## Requirements

* Firebase must initialize in `main.dart`
* Use `Firebase.initializeApp(...)`
* Use `DefaultFirebaseOptions.currentPlatform`
* Ensure Realtime Database support is ready
* Do not add authentication
* Do not add other Firebase products

## Important context

The Firebase project setup has already been done externally.
Use the existing configuration already present in the project.
Do not replace it with new project data.

## Deliverable for this step

* Confirm Firebase setup is correctly wired in Flutter
* Make only minimal changes if anything is missing

## Stop condition

Stop after this step and report:

* whether Firebase setup was already complete or needed edits
* files updated
* exact changes made

---

# Step 3 — Create `LockFirebaseService`

## Goal

Create a simple service that reads and writes lock state from Firebase Realtime Database.

## Requirements

Use the hardcoded path:

* `devices/guardian-lock-001`

Add these functions:

* `sendLockCommand()`
* `sendUnlockCommand()`
* `listenToLockState()`

### Command writes

When sending a command, write:

* `command`
* `commandId`
* `connectionMode = "internet"`

### The service must listen to:

* `status`
* `online`
* `lastSeen`
* `unlockBlocked`
* `connectionMode`

## Implementation notes

* Keep it small and readable.
* One device only.
* Do not add repository patterns or unnecessary abstraction.

## Deliverable for this step

A working `LockFirebaseService` ready to be connected to the UI.

## Stop condition

Stop after this step and report:

* files created/updated
* public methods added
* what database fields are read and written

---

# Step 4 — Connect the Front Door button to Firebase

## Goal

Connect the existing Front Door control button to the Firebase service.

## Requirements

The Front Door screen already contains one button.

### Button behavior

* If current state is `locked`, pressing the button should send `unlock`
* If current state is `unlocked`, pressing the button should send `lock`

### Wi-Fi / Internet connection rule

The command must only be sent if the selected connection mode in Settings is:

* `internet`

If the selected connection mode is not `internet`:

* do not send any Firebase command
* show this message:

  * `Internet control disabled. Enable Wi-Fi connection mode in Settings.`

### Screen state to show

Display these on the Front Door screen using Firebase data:

* current lock status
* current connection icon
* online/offline status

## Implementation notes

* Reuse the existing button.
* Do not redesign the page.
* Keep the integration minimal.

## Deliverable for this step

The existing Front Door screen can send lock/unlock commands through Firebase when connection mode is `internet`.

## Stop condition

Stop after this step and report:

* files updated
* how the button now works
* how the internet mode check is enforced

---

# Step 5 — Sync connection mode with Settings

## Goal

Make the Settings connection mode the source of truth for whether internet control is allowed.

## Requirements

Only one connection mode can be active at a time:

* `internet`
* `bluetooth`
* `local_wifi`

Store the selected mode in app state as:

* `connectionMode`

## Rules

* Internet mode corresponds to the Wi-Fi icon
* Firebase lock control is only allowed when:

  * `connectionMode == internet`
* If the mode is `bluetooth` or `local_wifi`, do not send Firebase commands from the Front Door button

## Implementation notes

* Use the existing Settings toggles
* Do not redesign the Settings screen
* Keep the state handling simple and consistent

## Deliverable for this step

The selected connection mode in Settings controls whether internet commands are allowed.

## Stop condition

Stop after this step and report:

* files updated
* how the selected connection mode is stored
* how the Front Door screen reads it

---

# Step 6 — Add safe database initialization

## Goal

Ensure the lock node exists in Firebase when the app starts, without overwriting existing values.

## Requirements

On app startup:

* check whether `devices/guardian-lock-001` exists
* if it does not exist, create it with:

```text
command = "none"
commandId = ""
status = "locked"
online = false
lastSeen = 0
unlockBlocked = false
connectionMode = "internet"
```

Do not overwrite existing real values.

## Implementation notes

* Keep it simple
* Prefer a small initializer/helper

## Deliverable for this step

The app safely creates the prototype lock node if it is missing.

## Stop condition

Stop after this step and report:

* files updated
* when initialization runs
* how overwriting existing data is prevented

---

# Step 7 — Generate ESP32 Arduino code

## Goal

Create Arduino IDE code for the ESP32 that listens to Firebase commands and triggers the relay.

## Requirements

Use these constants at the top of the file:

* `WIFI_SSID = GANA-26`
* `WIFI_PASSWORD = GANA+2020`
* `FIREBASE_DATABASE_URL = https://guardian-prototype-7f143-default-rtdb.europe-west1.firebasedatabase.app/`
* `DEVICE_ID = guardian-lock-001`
* `RELAY_PIN = 26`
* `RELAY_PULSE_MS = 3000`

### ESP32 behavior

Connect to:

* Wi-Fi
* Firebase Realtime Database

Monitor path:

* `devices/guardian-lock-001`

Read fields:

* `command`
* `commandId`
* `unlockBlocked`

When `command == "lock"`:

* trigger relay pulse
* update `status = "locked"`

When `command == "unlock"`:

* if `unlockBlocked == false`
* trigger relay pulse
* update `status = "unlocked"`

Update these fields regularly:

* `online = true`
* `lastSeen = timestamp`
* `connectionMode = "internet"`

After executing a command:

* set `command = "none"`

## Implementation notes

* Keep the sketch simple and readable
* Use a helper like `triggerRelayPulse()`
* Do not add extra hardware complexity

## Deliverable for this step

A complete Arduino IDE sketch for the one-lock prototype.

## Stop condition

Stop after this step and report:

* file created/updated
* constants used
* command handling flow

---

# Step 8 — Add command confirmation

## Goal

Let the app know whether the ESP32 actually executed the command.

## Requirements

Add support for these Firebase fields:

* `lastCommandId`
* `lastActionResult`

### ESP32 behavior

After executing a command, update:

* `lastCommandId`
* `lastActionResult`

### Flutter behavior

The app should display a simple success or failure message based on these values.

## Implementation notes

* Keep the UI simple
* One device only

## Deliverable for this step

Basic command confirmation from ESP32 back to the Flutter app.

## Stop condition

Stop after this step and report:

* files updated
* new Firebase fields used
* how confirmation is shown in the app

---

# Final handoff requirements

When all steps are complete, provide:

## 1. Final summary

* what was implemented
* what files were changed
* what the prototype can now do

## 2. Testing checklist

Provide a short checklist for testing the prototype end to end.

## 3. Values already set for this prototype

These should already be included in the Arduino sketch unless I ask to change them:

* `WIFI_SSID = GANA-26`
* `WIFI_PASSWORD = GANA+2020`
* `FIREBASE_DATABASE_URL = https://guardian-prototype-7f143-default-rtdb.europe-west1.firebasedatabase.app/`
* `RELAY_PIN = 26`
* `RELAY_PULSE_MS = 3000`

## 4. Keep the prototype simple

Do not add any extra features beyond this plan unless I explicitly ask for them.
