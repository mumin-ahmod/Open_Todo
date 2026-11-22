import 'package:flutter/material.dart';

import '../../core/constants/app_info.dart';
import '../../core/theme/app_colors.dart';
import '../pages/daily_progress_page.dart';
import '../pages/monthly_progress_page.dart';
import '../pages/info_page.dart';
import '../pages/settings_page.dart';
import '../pages/tags_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _open(BuildContext context, Widget page) async {
    Navigator.pop(context);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppInfo.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Minimal tasks, local-first',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _DrawerTile(
              icon: Icons.today_outlined,
              label: 'Daily progress',
              onTap: () => _open(context, const DailyProgressPage()),
            ),
            _DrawerTile(
              icon: Icons.bar_chart_rounded,
              label: 'Monthly progress',
              subtitle: 'Daily adds & completions',
              onTap: () => _open(context, const MonthlyProgressPage()),
            ),
            _DrawerTile(
              icon: Icons.sell_outlined,
              label: 'Tags',
              subtitle: 'Optional labels for todos',
              onTap: () => _open(context, const TagsPage()),
            ),
            _DrawerTile(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () => _open(context, const SettingsPage()),
            ),
            _DrawerTile(
              icon: Icons.info_outline,
              label: 'Info',
              onTap: () => _open(context, const InfoPage()),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'v${AppInfo.version}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
    );
  }
}