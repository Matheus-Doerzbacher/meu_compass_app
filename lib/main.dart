import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:meu_compass_app/config/dependencies.dart';
import 'package:provider/provider.dart';

void main() {
  Logger.root.level = Level.ALL;

  runApp(MultiProvider(
    providers: providers,
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: [],
    );
  }
}
