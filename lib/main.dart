import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:guardian/app.dart';
import 'package:guardian/features/shared/state/app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:guardian/core/services/lock_firebase_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const GuardianApp(),
    ),
  );

  await _initializeFirebaseForCurrentPlatform();

  if (Firebase.apps.isEmpty) {
    debugPrint('Skipping lock Firebase bootstrap because no Firebase app is available.');
    return;
  }

  // Do not block the first frame on Realtime Database setup.
  final lockService = LockFirebaseService();
  lockService.initializeLockIfNeeded().catchError((e) {
    debugPrint('Database initialization error: $e');
  });
}

Future<void> _initializeFirebaseForCurrentPlatform() async {
  try {
    if (Firebase.apps.isNotEmpty) {
      debugPrint('Firebase already initialized: ${Firebase.app().name}');
      return;
    }

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized from Dart bootstrap.');
  } catch (e, st) {
    debugPrint('Firebase bootstrap error: $e');
    debugPrint('$st');
  }
}
