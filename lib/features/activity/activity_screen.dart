import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/status_pill.dart';
import 'package:guardian/features/shared/models/activity_log_model.dart';
import 'package:guardian/features/shared/state/app_state.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  LogCategory? _filter;

  Color _severityColor(LogSeverity severity) {
    return switch (severity) {
      LogSeverity.info => AppColors.textMuted,
      LogSeverity.warning => AppColors.warning,
      LogSeverity.critical => AppColors.danger,
    };
  }

  String _formatTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${diff.inHours}h ago';
    }
  }

  void _showDetail(BuildContext context, ActivityLogModel log) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            StatusPill(
              label: log.category.name.toUpperCase(),
              color: _severityColor(log.severity),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              log.title,
              style: AppText.headingMed,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              log.description,
              style: AppText.bodyReg,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              log.timestamp.toString(),
              style: AppText.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, LogCategory? category) {
    return FilterChip(
      label: Text(label),
      selected: _filter == category,
      onSelected: (_) => setState(() => _filter = category),
      selectedColor: AppColors.neonBlue.withValues(alpha: 0.2),
      checkmarkColor: AppColors.neonBlue,
      side: BorderSide(
        color: _filter == category
            ? AppColors.neonBlue
            : AppColors.textMuted.withValues(alpha: 0.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final filtered = _filter == null
            ? appState.logs
            : appState.logs
                .where((l) => l.category == _filter)
                .toList();

        return GuardianScaffold(
          body: Column(
            children: [
              // Filter row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      _chip('All', null),
                      SizedBox(width: AppSpacing.sm),
                      _chip('Security', LogCategory.security),
                      SizedBox(width: AppSpacing.sm),
                      _chip('Environment', LogCategory.environment),
                      SizedBox(width: AppSpacing.sm),
                      _chip('System', LogCategory.system),
                    ],
                  ),
                ),
              ),
              // Log list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(AppSpacing.md),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final log = filtered[i];
                    return ListTile(
                      leading: Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _severityColor(log.severity),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      title: Text(
                        log.title,
                        style: AppText.bodyReg,
                      ),
                      subtitle: Text(
                        _formatTime(log.timestamp),
                        style: AppText.bodySmall,
                      ),
                      trailing: StatusPill(
                        label: log.severity.name.toUpperCase(),
                        color: _severityColor(log.severity),
                      ),
                      onTap: () => _showDetail(context, log),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
