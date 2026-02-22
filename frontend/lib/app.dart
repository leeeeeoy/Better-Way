import 'package:better_way/core/config/app_config.dart';
import 'package:better_way/resources/resources.dart';
import 'package:better_way/router/app_router.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: switch (appConfig.flavor) {
        .dev => 'Better Way Dev',
        .prod => 'Better Way',
      },
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      themeMode: .system,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
