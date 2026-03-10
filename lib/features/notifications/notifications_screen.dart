import 'package:flutter/material.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/glass_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final notifications = [
      {'message': 'Door unlocked successfully', 'time': '2 min ago'},
      {'message': 'Door locked', 'time': '1 hour ago'},
      {'message': 'New device connected', 'time': '3 hours ago'},
    ];

    return GuardianScaffold(
      title: 'Notifications',
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return GlassCard(
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.neonBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notif['message']!,
                        style: AppText.headingMed.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['time']!,
                        style: AppText.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
