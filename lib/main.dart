import 'package:daynight/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesService().init();

  runApp(ProviderScope(child: const MainApp()));
}
