import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GuardianScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const GuardianScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: title != null
          ? AppBar(
              title: Text(title!),
              actions: actions,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
