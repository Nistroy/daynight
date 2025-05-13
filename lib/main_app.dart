import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'day_night.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  );

  ThemeData _selectedTheme = ThemeData();

  @override
  Widget build(BuildContext context) {
    // Rebuild la page quand le provider change
    final day = ref.watch(dayNightProvider);
    if (day) {
      _selectedTheme = _lightTheme;
    } else {
      _selectedTheme = _darkTheme;
    }

    return MaterialApp(theme: _selectedTheme, home: DayNight());
  }
}
