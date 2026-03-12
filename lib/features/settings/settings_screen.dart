import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/glass_card.dart';
import 'package:guardian/core/widgets/section_header.dart';
import 'package:guardian/features/shared/state/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushEnabled = true;
  bool _connEnabled = true;
  bool _activityEnabled = false;

  IconData _getConnectionIcon(ConnectionMode mode) {
    return switch (mode) {
      ConnectionMode.internet => LucideIcons.wifi,
      ConnectionMode.bluetooth => LucideIcons.bluetooth,
      ConnectionMode.localWiFi => LucideIcons.houseWifi,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return GuardianScaffold(
          title: 'settings',
          actions: [
            Icon(
              _getConnectionIcon(appState.connectionMode),
              color: AppColors.textPrimary,
              size: 24,
            ),
            const SizedBox(width: 16),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/notifications'),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textMuted.withValues(alpha: 0.2),
              ),
            ),
            child: const Icon(
              LucideIcons.bell,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
      ],
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          SectionHeader(title: 'ACCOUNT'),
          SizedBox(height: AppSpacing.sm),
          GlassCard(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(LucideIcons.user, color: AppColors.neonBlue),
                  title: Text('Profile', style: AppText.bodyReg),
                  trailing: Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onTap: () {},
                ),
                Divider(color: AppColors.surface2),
                ListTile(
                  leading: Icon(LucideIcons.key, color: AppColors.neonBlue),
                  title: Text('Change Password', style: AppText.bodyReg),
                  trailing: Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onTap: () {},
                ),
                Divider(color: AppColors.surface2),
                ListTile(
                  leading: Icon(LucideIcons.shieldCheck, color: AppColors.neonBlue),
                  title: Row(
                    children: [
                      Text('Role', style: AppText.bodyReg),
                      SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neonBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.neonBlue.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          'ADMIN',
                          style: AppText.labelSmall.copyWith(
                            color: AppColors.neonBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
                Divider(color: AppColors.surface2),
                ListTile(
                  leading: Icon(LucideIcons.logOut, color: AppColors.danger),
                  title: Text(
                    'Logout',
                    style: AppText.bodyReg.copyWith(color: AppColors.danger),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'CONNECTION MODE'),
          SizedBox(height: AppSpacing.sm),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Internet Connection', style: AppText.bodyReg),
                  subtitle: Text('Control via cloud relay', style: AppText.bodySmall),
                  value: appState.connectionMode == ConnectionMode.internet,
                  activeThumbColor: AppColors.neonBlue,
                  onChanged: (v) {
                    if (v) appState.setConnectionMode(ConnectionMode.internet);
                  },
                ),
                Divider(color: AppColors.surface2, height: 1),
                SwitchListTile(
                  title: Text('Bluetooth Connection', style: AppText.bodyReg),
                  subtitle: Text('Direct proximity control', style: AppText.bodySmall),
                  value: appState.connectionMode == ConnectionMode.bluetooth,
                  activeThumbColor: AppColors.neonBlue,
                  onChanged: (v) {
                    if (v) appState.setConnectionMode(ConnectionMode.bluetooth);
                  },
                ),
                Divider(color: AppColors.surface2, height: 1),
                SwitchListTile(
                  title: Text('Local Wi-Fi Connection', style: AppText.bodyReg),
                  subtitle: Text('LAN-based device control', style: AppText.bodySmall),
                  value: appState.connectionMode == ConnectionMode.localWiFi,
                  activeThumbColor: AppColors.neonBlue,
                  onChanged: (v) {
                    if (v) appState.setConnectionMode(ConnectionMode.localWiFi);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'NOTIFICATIONS'),
          SizedBox(height: AppSpacing.sm),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Push Notifications', style: AppText.bodyReg),
                  subtitle: Text('Security alerts and events', style: AppText.bodySmall),
                  value: _pushEnabled,
                  activeThumbColor: AppColors.neonBlue,
                  onChanged: (v) => setState(() => _pushEnabled = v),
                ),
                Divider(color: AppColors.surface2, height: 1),
                SwitchListTile(
                  title: Text('Connection Alerts', style: AppText.bodyReg),
                  subtitle: Text('Device offline/online status', style: AppText.bodySmall),
                  value: _connEnabled,
                  activeThumbColor: AppColors.neonBlue,
                  onChanged: (v) => setState(() => _connEnabled = v),
                ),
                Divider(color: AppColors.surface2, height: 1),
                SwitchListTile(
                  title: Text('Activity Log Alerts', style: AppText.bodyReg),
                  subtitle: Text('Critical log entries and events', style: AppText.bodySmall),
                  value: _activityEnabled,
                  activeThumbColor: AppColors.neonBlue,
                  onChanged: (v) => setState(() => _activityEnabled = v),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'DEVICES'),
          SizedBox(height: AppSpacing.sm),
          GlassCard(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(LucideIcons.tablet, color: AppColors.neonBlue),
                  title: Text('My Devices', style: AppText.bodyReg),
                  trailing: Icon(LucideIcons.chevronRight, color: AppColors.textMuted, size: 20),
                  onTap: () {},
                ),
                Divider(color: AppColors.surface2),
                ListTile(
                  leading: Icon(LucideIcons.pencil, color: AppColors.neonBlue),
                  title: Text('Rename Device', style: AppText.bodyReg),
                  trailing: Icon(LucideIcons.chevronRight, color: AppColors.textMuted, size: 20),
                  onTap: () {},
                ),
                Divider(color: AppColors.surface2),
                ListTile(
                  leading: Icon(LucideIcons.trash2, color: AppColors.danger),
                  title: Text('Remove Device', style: AppText.bodyReg.copyWith(color: AppColors.danger)),
                  onTap: () {},
                ),
                Divider(color: AppColors.surface2),
                ListTile(
                  leading: Icon(LucideIcons.circlePlus, color: AppColors.success),
                  title: Text('Add Device', style: AppText.bodyReg.copyWith(color: AppColors.success)),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'ABOUT'),
          SizedBox(height: AppSpacing.sm),
          GlassCard(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    LucideIcons.info,
                    color: AppColors.neonBlue,
                  ),
                  title: Text(
                    'Guardian',
                    style: AppText.bodyReg,
                  ),
                  subtitle: Text(
                    'v1.0.0 · Demo Build',
                    style: AppText.bodySmall,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    LucideIcons.gavel,
                    color: AppColors.textMuted,
                  ),
                  title: Text(
                    'Licenses',
                    style: AppText.bodyReg,
                  ),
                  subtitle: Text(
                    'Open source components',
                    style: AppText.bodySmall,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Open Source · MIT'),
                        backgroundColor: AppColors.surface,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
          ),
        );
      },
    );
  }
}
