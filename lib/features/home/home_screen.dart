import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/glass_card.dart';
import 'package:guardian/core/widgets/status_pill.dart';
import 'package:guardian/core/widgets/section_header.dart';
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
                // Header section
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back, Admin', style: AppText.displayLarge),
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          StatusPill(
                            label: 'All Systems Secure',
                            color: AppColors.success,
                          ),
                          const Spacer(),
                          StatusPill(
                            label: appState.isLocalMode
                                ? 'Local Mode'
                                : 'Cloud',
                            color: appState.isLocalMode
                                ? AppColors.warning
                                : AppColors.neonBlue,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          IconButton(
                            icon: Icon(
                              Icons.sync,
                              color: AppColors.neonBlue,
                              size: 18,
                            ),
                            onPressed: () =>
                                context.read<AppState>().toggleLocalMode(),
                            tooltip: 'Toggle connection mode',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Section header
                SectionHeader(title: 'Devices'),
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
      DeviceType.lock => Icons.lock,
      DeviceType.light => Icons.lightbulb,
      DeviceType.climate => Icons.thermostat,
    };
  }

  Color _colorForDevice(DeviceModel device) {
    return switch (device.type) {
      DeviceType.lock => device.isLocked ? AppColors.success : AppColors.danger,
      DeviceType.light => device.isOn ? AppColors.warning : AppColors.textMuted,
      DeviceType.climate => AppColors.neonBlue,
    };
  }

  String _statusLabel(DeviceModel device) {
    return switch (device.type) {
      DeviceType.lock => device.isLocked ? 'Locked' : 'Unlocked',
      DeviceType.light => device.isOn ? 'On' : 'Off',
      DeviceType.climate => '0.0°C',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isLock = device.type == DeviceType.lock;
    final isDisconnected = !isLock;

    return Hero(
      tag: device.id,
      child: GlassCard(
        onTap: () {
          final route = switch (device.type) {
            DeviceType.lock => '/device-lock',
            DeviceType.light => '/device-light',
            DeviceType.climate => '/device-climate',
          };
          Navigator.pushNamed(context, route, arguments: device.id);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: isDisconnected ? 0.65 : 1.0,
                    child: Icon(
                      _iconForType(device.type),
                      color: _colorForDevice(device),
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 8),
                  Opacity(
                    opacity: isDisconnected ? 0.65 : 1.0,
                    child: Text(
                      device.name,
                      style: AppText.bodyReg,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
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
            if (isDisconnected)
              Positioned(
                top: 3,
                right: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.textMuted.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        color: AppColors.textMuted,
                        size: 10,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'Offline',
                        style: AppText.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
