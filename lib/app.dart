import 'package:flutter/material.dart';
import 'package:guardian/core/theme/app_theme.dart';
import 'package:guardian/features/splash/splash_screen.dart';
import 'package:guardian/features/onboarding/onboarding_screen.dart';
import 'package:guardian/features/main_shell/main_shell.dart';
import 'package:guardian/features/add_device/add_device_screen.dart';
import 'package:guardian/features/shared/screens/lock_screen.dart';
import 'package:guardian/features/notifications/notifications_screen.dart';


class GuardianApp extends StatelessWidget {
  const GuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/main': (_) => const MainShell(),
        '/device-lock': (_) => const LockScreen(),

        '/add-device': (_) => const AddDeviceScreen(),
        '/notifications': (_) => const NotificationsScreen(),
      },
    );
  }
}
