import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_settings.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/page_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: 'Settings'),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Dark theme'),
                subtitle: const Text('Use dark mode across the app'),
                value: settings.useDarkTheme,
                onChanged: (v) => context.read<SettingsCubit>().setDarkTheme(v),
              ),
              SwitchListTile(
                title: const Text('Show date & time'),
                subtitle: const Text('Display timestamps on todo items'),
                value: settings.showDateTime,
                onChanged: (v) => context.read<SettingsCubit>().setShowDateTime(v),
              ),
            ],
          );
        },
      ),
    );
  }
}