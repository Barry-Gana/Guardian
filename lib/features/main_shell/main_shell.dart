import 'package:flutter/material.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/features/home/home_screen.dart';
import 'package:guardian/features/ai/ai_screen.dart';
import 'package:guardian/features/control/control_screen.dart';
import 'package:guardian/features/settings/settings_screen.dart';
import 'package:guardian/features/main_shell/glass_nav_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const HomeScreen(),
    const AiScreen(),
    const ControlScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final navHeight = 70.0;
    final navMarginBottom = 24.0;
    final extraPadding = 12.0;
    final totalBottomPadding = navHeight + navMarginBottom + bottomSafeArea + extraPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: totalBottomPadding),
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          GlassNavBar(
            selectedIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            onAddDevice: () => Navigator.pushNamed(context, '/add-device'),
          ),
        ],
      ),
    );
  }
}
