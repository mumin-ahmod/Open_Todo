import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'domain/entities/app_settings.dart';
import 'presentation/bloc/tag_bloc.dart';
import 'presentation/bloc/tag_event.dart';
import 'presentation/bloc/todo_bloc.dart';
import 'presentation/bloc/todo_event.dart';
import 'presentation/cubit/settings_cubit.dart';
import 'presentation/pages/home_page.dart';

class OpenTodoApp extends StatelessWidget {
  const OpenTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<SettingsCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => sl<TodoBloc>()..add(const TodoStarted()),
        ),
        BlocProvider(
          create: (_) => sl<TagBloc>()..add(const TagStarted()),
        ),
      ],
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          return MaterialApp(
            title: 'Open Todo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}