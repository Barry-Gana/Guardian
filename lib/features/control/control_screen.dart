import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/glass_card.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GuardianScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Text('Control', style: AppText.displayLarge),
            const SizedBox(height: AppSpacing.xs),
            Text('Manage your smart lock automations', style: AppText.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            _ControlSectionCard(
              icon: LucideIcons.calendarClock,
              title: 'Schedules',
              subtitle: 'Set time-based lock & unlock rules',
              accentColor: AppColors.neonBlue,
              children: const [
                _EmptyStateHint(message: 'No schedules yet. Tap + to add one.'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _ControlSectionCard(
              icon: LucideIcons.sparkles,
              title: 'Scenes',
              subtitle: 'Group actions into one-tap presets',
              accentColor: AppColors.success,
              children: const [
                _EmptyStateHint(message: 'No scenes yet. Tap + to add one.'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _ControlSectionCard(
              icon: LucideIcons.zap,
              title: 'Automations',
              subtitle: 'Trigger actions based on events',
              accentColor: AppColors.warning,
              children: const [
                _EmptyStateHint(message: 'No automations yet. Tap + to add one.'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _ControlSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final List<Widget> children;

  const _ControlSectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.12),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.headingMed),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppText.bodySmall),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Icon(
                      LucideIcons.plus,
                      color: accentColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Divider
          Container(
            height: 1,
            color: AppColors.textMuted.withValues(alpha: 0.12),
          ),
          const SizedBox(height: AppSpacing.md),
          // Content
          ...children,
        ],
      ),
    );
  }
}

class _EmptyStateHint extends StatelessWidget {
  final String message;

  const _EmptyStateHint({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Text(
          message,
          style: AppText.bodySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
