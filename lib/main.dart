import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:meu_compass_app/config/dependencies.dart';
import 'package:meu_compass_app/ui/core/localization/applocalization.dart';
import 'package:meu_compass_app/ui/core/themes/theme.dart';
import 'package:meu_compass_app/ui/core/ui/scroll_behavior.dart';
import 'package:provider/provider.dart';
import 'routing/router.dart';

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
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        AppLocalizationDelegate()
      ],
      scrollBehavior: AppCustomScrollBehavior(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router(context.read()),
    );
  }
}
