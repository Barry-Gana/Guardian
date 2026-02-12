import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

class AnimatedGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final bool pulsing;

  const AnimatedGlow({
    super.key,
    required this.child,
    this.glowColor = AppColors.neonBlue,
    this.pulsing = true,
  });

  @override
  State<AnimatedGlow> createState() => _AnimatedGlowState();
}

class _AnimatedGlowState extends State<AnimatedGlow> {
  bool _bright = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.pulsing) {
      _timer = Timer.periodic(AppMotion.slow, (_) {
        setState(() {
          _bright = !_bright;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.slow,
      curve: AppMotion.smooth,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.glowColor.withValues(alpha: _bright ? 0.5 : 0.1),
            blurRadius: _bright ? 24 : 8,
          ),
        ],
      ),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
