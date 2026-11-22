import 'package:flutter/material.dart';

/// Minimal control to open the scaffold drawer.
class DrawerMenuButton extends StatelessWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Open menu',
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: Icon(
        Icons.segment_rounded,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}