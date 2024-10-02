import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_plus/utils/dark_theme.dart';
import 'package:notes_plus/utils/light_theme.dart';
import 'package:notes_plus/views/home/bloc/home_bloc.dart';
import 'core/settings_controller.dart';
import 'views/home/home_view.dart';
import 'views/settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          theme: lightThemeData(settingsController),
          darkTheme: darkThemeData(settingsController),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(
                      settingsController: settingsController,
                    );

                  case HomeView.routeName:
                  default:
                    return HomeView();
                }
              },
            );
          },
        );
      },
    );
  }
}
