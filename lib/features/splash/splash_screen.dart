import 'package:flutter/material.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/theme/app_motion.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/animated_glow.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);
      Future.delayed(const Duration(milliseconds: 1300), () {
        if (mounted) Navigator.pushReplacementNamed(context, '/onboarding');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GuardianScaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: AppMotion.slow,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedGlow(
                child: Icon(
                  Icons.shield,
                  size: 80,
                  color: AppColors.neonBlue,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'GUARDIAN',
                style: AppText.displayLarge.copyWith(
                  letterSpacing: 8,
                  color: AppColors.neonBlue,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'SECURE INTELLIGENCE PLATFORM',
                style: AppText.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
