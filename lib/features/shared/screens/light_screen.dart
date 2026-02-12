import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/theme/app_motion.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/glass_card.dart';
import 'package:guardian/core/widgets/section_header.dart';
import 'package:guardian/features/shared/state/app_state.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});

  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceId =
        ModalRoute.of(context)!.settings.arguments as String;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final device = appState.devices.firstWhere((d) => d.id == deviceId);

        return GuardianScaffold(
          title: device.name,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: device.id,
                    child: Icon(
                      Icons.lightbulb,
                      size: 40,
                      color: AppColors.neonBlue,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  AnimatedContainer(
                    duration: AppMotion.med,
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: device.isOn
                        ? AppColors.warning.withValues(alpha: 0.15)
                          : AppColors.surface2,
                      border: Border.all(
                        color: device.isOn
                            ? AppColors.warning
                            : AppColors.textMuted,
                        width: 2,
                      ),
                      boxShadow: device.isOn
                          ? [
                              BoxShadow(
                                color: AppColors.warning.withValues(alpha: 0.35),
                                blurRadius: 30,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lightbulb,
                        size: 72,
                        color: device.isOn
                            ? AppColors.warning
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    device.isOn ? 'LIGHT ON' : 'LIGHT OFF',
                    style: AppText.labelMono,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Last changed: just now',
                    style: AppText.bodySmall,
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      value: device.isOn,
                      onChanged: (_) {
                        context.read<AppState>().toggleLight(device.id);
                      },
                      activeThumbColor: AppColors.warning,
                      activeTrackColor: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  SectionHeader(title: 'AI INSIGHT'),
                  SizedBox(height: AppSpacing.sm),
                  GlassCard(
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppColors.neonBlue,
                          size: 20,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'This device is disconnected.',
                            style: AppText.bodyReg,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
