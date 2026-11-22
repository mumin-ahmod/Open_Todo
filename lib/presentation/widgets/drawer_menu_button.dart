import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Opens the scaffold drawer with a sidebar-style control (not a hamburger).
class DrawerMenuButton extends StatelessWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        tooltip: 'Open menu',
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.2 : 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? accent.withValues(alpha: 0.35)
                  : AppColors.seedGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            Icons.view_sidebar_rounded,
            size: 22,
            color: accent,
          ),
        ),
      ),
    );
  }
}