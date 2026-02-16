import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rich/core/di/injection.dart';
import 'package:rich/core/theme/spacex_theme.dart';
import 'package:rich/features/spacex/presentation/pages/spacex_page.dart';
import 'package:rich/l10n/app_localizations.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rich',
      debugShowCheckedModeBanner: false,
      theme: SpaceXTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: const SpaceXPage(),
    );
  }
}
