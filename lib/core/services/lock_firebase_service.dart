import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:guardian/core/constants/firebase_constants.dart';

/// A simple service to read and write lock state from Firebase Realtime Database.
///
/// Interacts with the hardcoded 'devices/guardian-lock-001' path.
class LockFirebaseService {
  static final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: LockFirebaseConstants.databaseUrl,
  );

  final DatabaseReference _lockRef = _database.ref(LockFirebaseConstants.lockPath);

  /// Ensures the lock node exists in Firebase on app startup without overwriting existing values.
  Future<void> initializeLockIfNeeded() async {
    debugPrint(
      '[LockFirebaseService] initializeLockIfNeeded() on ${LockFirebaseConstants.lockPath}',
    );
    final snapshot = await _lockRef.get();
    
    if (!snapshot.exists) {
      await _lockRef.set({
        LockFirebaseConstants.command: 'none',
        LockFirebaseConstants.commandId: '',
        LockFirebaseConstants.status: 'locked',
        LockFirebaseConstants.online: false,
        LockFirebaseConstants.lastSeen: 0,
        LockFirebaseConstants.unlockBlocked: false,
        LockFirebaseConstants.connectionMode: 'internet',
        LockFirebaseConstants.lastCommandId: '',
        LockFirebaseConstants.lastActionResult: '',
      });
      debugPrint('[LockFirebaseService] Created initial lock node.');
    }
  }

  /// Sends either 'lock' or 'unlock' with a caller-provided unique commandId.
  Future<void> sendCommand({
    required String command,
    required String commandId,
  }) async {
    final payload = {
      LockFirebaseConstants.command: command,
      LockFirebaseConstants.commandId: commandId,
      LockFirebaseConstants.connectionMode: 'internet',
    };

    debugPrint(
      '[LockFirebaseService] Command write attempt -> path=${LockFirebaseConstants.lockPath} payload=$payload',
    );
    await _lockRef.update(payload);
    debugPrint('[LockFirebaseService] Command write success.');
  }

  /// Returns a stream of the lock's state changes.
  /// Re-emits whenever status, online, lastSeen, unlockBlocked, or connectionMode change.
  Stream<DatabaseEvent> listenToLockState() {
    return _lockRef.onValue;
  }
}
