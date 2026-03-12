/// Shared Firebase constants for the Guardian Smart Lock prototype.
/// 
/// These constants define the single source of truth for the database path
/// and field names used by both the Flutter app and the ESP32 code.
/// 
/// FIREBASE DATA STRUCTURE
/// 
/// {
///   "devices": {
///     "guardian-lock-001": {
///       "command": "none",
///       "commandId": "",
///       "status": "locked",
///       "online": false,
///       "lastSeen": 0,
///       "unlockBlocked": false,
///       "connectionMode": "internet"
///     }
///   }
/// }
/// 
class LockFirebaseConstants {
  // Prevent instantiation
  LockFirebaseConstants._();

  /// The Realtime Database URL used by both Flutter and ESP32.
  static const String databaseUrl =
      'https://guardian-prototype-7f143-default-rtdb.europe-west1.firebasedatabase.app';

  /// The hardcoded lock ID for the one-device prototype.
  static const String deviceId = 'guardian-lock-001';

  /// The hardcoded database path for the prototype lock.
  static const String lockPath = 'devices/$deviceId';

  // --- Field Names ---

  /// The command sent to the lock (e.g., 'lock', 'unlock', 'none').
  static const String command = 'command';

  /// A unique ID for the command to allow the ESP32 to confirm execution.
  static const String commandId = 'commandId';

  /// The current physical status of the lock (e.g., 'locked', 'unlocked').
  static const String status = 'status';

  /// Whether the ESP32 considers itself online.
  static const String online = 'online';

  /// The timestamp when the ESP32 was last seen.
  static const String lastSeen = 'lastSeen';

  /// Whether unlocking is currently blocked.
  static const String unlockBlocked = 'unlockBlocked';

  /// The connection mode ('internet', 'bluetooth', 'local_wifi').
  static const String connectionMode = 'connectionMode';

  /// The ID of the last command executed by the ESP32.
  static const String lastCommandId = 'lastCommandId';

  /// The result of the last command executed ('success', 'failed', 'blocked').
  static const String lastActionResult = 'lastActionResult';
}
