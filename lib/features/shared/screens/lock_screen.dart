import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/theme/app_motion.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/neon_button.dart';
import 'package:guardian/features/shared/state/app_state.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceId =
        ModalRoute.of(context)!.settings.arguments as String;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final device = appState.devices.firstWhere((d) => d.id == deviceId);

        return GuardianScaffold(
          title: device.name,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: device.id,
                  child: Icon(
                    device.isLocked ? LucideIcons.lock : LucideIcons.lockOpen,
                    size: 40,
                    color: AppColors.neonBlue,
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                AnimatedContainer(
                  duration: AppMotion.med,
                  curve: AppMotion.smooth,
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: device.isLocked
                          ? AppColors.success
                          : AppColors.danger,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (device.isLocked
                                ? AppColors.success
                                : AppColors.danger)
                            .withValues(alpha: 0.4),
                        blurRadius:
                            device.isLocked ? 24 : 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      device.isLocked ? LucideIcons.lock : LucideIcons.lockOpen,
                      size: 72,
                      color: device.isLocked
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  device.isLocked ? 'LOCKED' : 'UNLOCKED',
                  style: AppText.labelMono.copyWith(fontSize: 18),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Auto-lock: Enabled · 30s',
                  style: AppText.bodySmall,
                ),
                SizedBox(height: AppSpacing.lg),
                NeonButton(
                  label: device.isLocked ? 'UNLOCK' : 'LOCK',
                  onPressed: () {
                    context.read<AppState>().toggleLock(device.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
