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
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.trash2),
              color: AppColors.textPrimary,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(LucideIcons.wifi),
              color: AppColors.textPrimary,
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: device.id,
                  child: AnimatedContainer(
                    duration: AppMotion.med,
                    curve: AppMotion.smooth,
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: device.isLocked
                            ? AppColors.success
                            : AppColors.danger,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (device.isLocked
                                  ? AppColors.success
                                  : AppColors.danger)
                              .withValues(alpha: 0.4),
                          blurRadius:
                              device.isLocked ? 32 : 12,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        device.isLocked ? LucideIcons.doorClosed : LucideIcons.doorOpen,
                        size: 100,
                        color: device.isLocked
                            ? AppColors.success
                            : AppColors.danger,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  device.isLocked ? 'LOCKED' : 'UNLOCKED',
                  style: AppText.labelMono.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
