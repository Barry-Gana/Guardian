import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool small;
  final bool outlined;

  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.small = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = outlined ? _buildOutlinedButton() : _buildFilledButton();

    if (outlined) {
      return button;
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.neonBlue.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: button,
    );
  }

  Widget _buildFilledButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.neonBlue,
        foregroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: small ? AppSpacing.sm : AppSpacing.lg,
          vertical: small ? AppSpacing.xs : AppSpacing.sm,
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(
          color: AppColors.neonBlue,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: small ? AppSpacing.sm : AppSpacing.lg,
          vertical: small ? AppSpacing.xs : AppSpacing.sm,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.neonBlue),
      ),
    );
  }
}
