import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: AppText.labelSmall,
      ),
    );
  }
}
