import 'package:flutter/material.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/theme/app_motion.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/neon_button.dart';

class _PageData {
  final IconData icon;
  final String title;
  final String description;

  _PageData(this.icon, this.title, this.description);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _ctrl;
  int _page = 0;

  final _pages = [
    _PageData(
      Icons.security,
      'Secure Infrastructure',
      'Local control, cloud optional, private deployments.',
    ),
    _PageData(
      Icons.psychology,
      'AI-Driven Monitoring',
      'Guardian AI detects unusual behavior instantly.',
    ),
    _PageData(
      Icons.hub,
      'Scalable IoT Deployment',
      'Add devices gradually, from home to city-scale.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _buildPage(_PageData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          data.icon,
          size: 80,
          color: AppColors.neonBlue,
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          data.title,
          style: AppText.headingMed,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.md),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            data.description,
            style: AppText.bodyReg,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GuardianScaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _ctrl,
              onPageChanged: (i) => setState(() => _page = i),
              itemCount: 3,
              itemBuilder: (_, i) => _buildPage(_pages[i]),
            ),
          ),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => AnimatedContainer(
                duration: AppMotion.med,
                margin: const EdgeInsets.all(4),
                width: _page == i ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _page == i ? AppColors.neonBlue : AppColors.textMuted,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: NeonButton(
              label: 'Enter Guardian',
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/main'),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
