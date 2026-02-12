import 'package:flutter/material.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/glass_card.dart';
import 'package:guardian/core/widgets/section_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _deployCloud = false;
  bool _notifs = true;

  @override
  Widget build(BuildContext context) {
    return GuardianScaffold(
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          // Profile
          GlassCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.surface2,
                  child: Icon(
                    Icons.shield,
                    color: AppColors.neonBlue,
                    size: 28,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin',
                      style: AppText.headingMed,
                    ),
                    Text(
                      'Guardian Administrator',
                      style: AppText.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'DEPLOYMENT'),
          SizedBox(height: AppSpacing.sm),
          // Deployment mode
          GlassCard(
            child: Column(
              children: [
                _DeployOption(
                  title: 'Cloud Connected',
                  subtitle: 'Managed cloud infrastructure',
                  icon: Icons.cloud,
                  selected: _deployCloud,
                  onTap: () => setState(() => _deployCloud = true),
                ),
                Divider(color: AppColors.surface2),
                _DeployOption(
                  title: 'Private Local Server',
                  subtitle: 'Air-gapped / on-premise',
                  icon: Icons.storage,
                  selected: !_deployCloud,
                  badge: 'ENTERPRISE',
                  onTap: () => setState(() => _deployCloud = false),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          SectionHeader(title: 'NOTIFICATIONS'),
          SizedBox(height: AppSpacing.sm),
          GlassCard(
            padding: EdgeInsets.zero,
            child: SwitchListTile(
              title: Text(
                'Security Alerts',
                style: AppText.bodyReg,
              ),
              subtitle: Text(
                'Push notifications for events',
                style: AppText.bodySmall,
              ),
              value: _notifs,
              activeThumbColor: AppColors.neonBlue,
              onChanged: (v) => setState(() => _notifs = v),
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
                    Icons.info_outline,
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
                    Icons.gavel_outlined,
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
  }
}

class _DeployOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  const _DeployOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? AppColors.neonBlue : AppColors.textMuted,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppText.bodyReg,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (badge != null) ...[
            SizedBox(width: AppSpacing.xs),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.neonBlue.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badge!,
                style: AppText.labelSmall.copyWith(
                  color: AppColors.neonBlue,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        subtitle,
        style: AppText.bodySmall,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: selected
          ? Icon(
              Icons.check_circle,
              color: AppColors.neonBlue,
            )
          : null,
      onTap: onTap,
    );
  }
}
