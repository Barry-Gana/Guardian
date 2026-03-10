import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/glass_card.dart';
import 'package:guardian/core/widgets/status_pill.dart';
import 'package:guardian/features/shared/models/device_model.dart';
import 'package:guardian/features/shared/state/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return GuardianScaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Section header
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Devices',
                      style: AppText.displayLarge,
                    ),
                  ),
                ),
                // Device grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.95,
                        ),
                    itemCount: appState.devices.length,
                    itemBuilder: (context, index) {
                      return _DeviceCard(appState.devices[index]);
                    },
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final DeviceModel device;

  const _DeviceCard(this.device);

  IconData _iconForType(DeviceType type) {
    return switch (type) {
      DeviceType.lock => LucideIcons.lock,
    };
  }

  Color _colorForDevice(DeviceModel device) {
    return switch (device.type) {
      DeviceType.lock => device.isLocked ? AppColors.success : AppColors.danger,
    };
  }

  String _statusLabel(DeviceModel device) {
    return switch (device.type) {
      DeviceType.lock => device.isLocked ? 'Locked' : 'Unlocked',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: device.id,
      child: GlassCard(
        onTap: () {
          final route = switch (device.type) {
            DeviceType.lock => '/device-lock',
          };
          Navigator.pushNamed(context, route, arguments: device.id);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                _iconForType(device.type),
                color: _colorForDevice(device),
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                device.name,
                style: AppText.bodyReg,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
              Text(
                device.room,
                style: AppText.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xs),
              StatusPill(
                label: _statusLabel(device),
                color: _colorForDevice(device),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
