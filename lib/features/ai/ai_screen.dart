import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/theme/app_motion.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/animated_glow.dart';
import 'package:guardian/core/widgets/glass_card.dart';
import 'package:guardian/features/shared/models/chat_message_model.dart';
import 'package:guardian/features/shared/state/app_state.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  late TextEditingController _ctrl;
  late ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
    _scroll = ScrollController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String text, BuildContext context) {
    if (text.trim().isEmpty) return;
    context.read<AppState>().addUserChat(text);
    _ctrl.clear();
  }

  IconData _iconForType(MessageType t) => switch (t) {
    MessageType.status => LucideIcons.circleCheck,
    MessageType.alert => LucideIcons.triangleAlert,
    MessageType.insight => LucideIcons.sparkles,
  };

  Color _colorForType(MessageType t) => switch (t) {
    MessageType.status => AppColors.success,
    MessageType.alert => AppColors.warning,
    MessageType.insight => AppColors.neonBlue,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return GuardianScaffold(
          body: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Text(
                      'Guardian AI',
                      style: AppText.headingMed,
                    ),
                    const Spacer(),
                    _PulsingDot(),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Monitoring',
                      style: AppText.bodySmall,
                    ),
                  ],
                ),
              ),
              // Avatar
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: AnimatedGlow(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.surface2,
                      child: Icon(
                        LucideIcons.bot,
                        size: 36,
                        color: AppColors.neonBlue,
                      ),
                    ),
                  ),
                ),
              ),
              // Chat list
              Expanded(
                child: ListView.builder(
                  controller: _scroll,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: appState.messages.length,
                  itemBuilder: (_, i) {
                    final msg = appState.messages[i];
                    final isUser = msg.sender == ChatSender.user;
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: AppMotion.med,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.75,
                          ),
                          margin: EdgeInsets.only(bottom: AppSpacing.sm),
                          child: isUser
                              ? Container(
                                  padding: EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface2,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    msg.text,
                                      style: AppText.bodyReg,
                                  ),
                                )
                              : GlassCard(
                                  padding: EdgeInsets.all(AppSpacing.sm),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        _iconForType(msg.messageType),
                                        size: 14,
                                        color: _colorForType(msg.messageType),
                                      ),
                                      SizedBox(width: AppSpacing.xs),
                                      Expanded(
                                        child: Text(
                                          msg.text,
                                          style: AppText.bodyReg,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Quick chips
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    'System Status',
                    'Last Alerts',
                    'Secure Home',
                  ]
                      .map(
                        (label) => ActionChip(
                          label: Text(
                            label,
                            style: AppText.bodySmall,
                          ),
                          backgroundColor: AppColors.surface2,
                          side: BorderSide(
                            color:
                                AppColors.neonBlue.withValues(alpha: 0.4),
                          ),
                          onPressed: () => _send(label, context),
                        ),
                      )
                      .toList(),
                ),
              ),
              // Input row
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        style: AppText.bodyReg,
                        decoration: InputDecoration(
                          hintText: 'Ask Guardian...',
                          hintStyle: AppText.bodySmall,
                          filled: true,
                          fillColor: AppColors.surface2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.neonBlue.withValues(alpha: 0.3),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                        onSubmitted: (v) => _send(v, context),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: Icon(
                        LucideIcons.send,
                        color: AppColors.neonBlue,
                      ),
                      onPressed: () => _send(_ctrl.text, context),
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

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> {
  double _opacity = 0.3;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(AppMotion.slow, (_) {
      setState(() => _opacity = _opacity < 0.6 ? 1.0 : 0.3);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: AppMotion.slow,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
        ),
      ),
    );
  }
}
