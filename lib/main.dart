import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardian/app.dart';
import 'package:guardian/features/shared/state/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const GuardianApp(),
    ),
  );
}
