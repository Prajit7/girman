import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_plus/firebase_options.dart';
import 'package:notes_plus/services/firestore_services.dart';
import 'package:notes_plus/services/shared_preferences_services.dart';
import 'package:notes_plus/views/home/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'app.dart';
import 'core/settings_controller.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Instantiate Firebase
  List futureValues = await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    getDatabasesPath(),
    SharedPreferences.getInstance(),
  ]);
  final SharedPreferences sharedPreferences = futureValues[2];

  final SharedPreferencesServices sharedPreferencesServices =
      SharedPreferencesServices(
    sharedPreferences,
  );

  // Instantiate Controllers
  final SettingsController settingsController = SettingsController(
    SettingsService(sharedPreferencesServices: sharedPreferencesServices),
  );

  await Future.wait([
    settingsController.loadSettings(),
  ]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
      ],
      child: MyApp(
        settingsController: settingsController,
      ),
    ),
  );
}
