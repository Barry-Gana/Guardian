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

class ClimateScreen extends StatefulWidget {
  const ClimateScreen({super.key});

  @override
  State<ClimateScreen> createState() => _ClimateScreenState();
}

class _ClimateScreenState extends State<ClimateScreen> {
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
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: 'Environment'),
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: GlassCard(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  SectionHeader(title: 'TEMPERATURE'),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(
                                      begin: 0,
                                      end: 0.0,
                                    ),
                                    duration: AppMotion.slow,
                                    builder: (_, val, _) => Text(
                                      '${val.toStringAsFixed(1)}°C',
                                      style: AppText.displayLarge.copyWith(
                                        color: AppColors.neonBlue,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Celsius',
                                    style: AppText.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: GlassCard(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  SectionHeader(title: 'HUMIDITY'),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(
                                      begin: 0,
                                      end: 0.0,
                                    ),
                                    duration: AppMotion.slow,
                                    builder: (_, val, _) => Text(
                                      '${val.toStringAsFixed(1)}%',
                                      style: AppText.displayLarge.copyWith(
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Relative',
                                    style: AppText.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
              ],
            ),
          ),
        );
      },
    );
  }
}
