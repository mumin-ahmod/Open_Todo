import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.useDarkTheme = false,
    this.showDateTime = true,
  });

  final bool useDarkTheme;
  final bool showDateTime;

  ThemeMode get themeMode => useDarkTheme ? ThemeMode.dark : ThemeMode.light;

  AppSettings copyWith({bool? useDarkTheme, bool? showDateTime}) {
    return AppSettings(
      useDarkTheme: useDarkTheme ?? this.useDarkTheme,
      showDateTime: showDateTime ?? this.showDateTime,
    );
  }

  @override
  List<Object?> get props => [useDarkTheme, showDateTime];
}