import 'package:flutter/material.dart';

import '../../core/constants/app_info.dart';
import '../../core/platform/app_platform.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/page_app_bar.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = PlatformResolver.current.displayName;

    return Scaffold(
      appBar: const PageAppBar(title: 'Info'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            AppInfo.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version ${AppInfo.version} (${AppInfo.build})',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          const _InfoRow(
            icon: Icons.person_outline,
            title: 'Developer',
            body: AppInfo.developer,
          ),
          const _InfoRow(
            icon: Icons.code,
            title: 'Open source',
            body: 'Completely open source — fork it, ship it, improve it.',
          ),
          const _InfoRow(
            icon: Icons.lock_outline,
            title: 'Privacy',
            body: '100% stored in local storage on your device.',
          ),
          _InfoRow(
            icon: Icons.devices_other_outlined,
            title: 'Available for',
            body: '${AppInfo.platforms.join(', ')}. Running on $platform.',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.seedGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}