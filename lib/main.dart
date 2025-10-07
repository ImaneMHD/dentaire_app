import 'package:dentaire/utilities/Navigation/routes.dart';
import 'package:dentaire/view/screens/common_screens/welcom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:dentaire/firebase_options.dart';
import 'package:dentaire/view/themes/custom_light_theme.dart';
import 'package:dentaire/view/themes/cutom_dark_theme.dart';

void main() async {
  // Étape 1 : S'assurer que les widgets sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Étape 2 : Initialiser Firebase avant de lancer l'application
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Créer une instance de Firebase Analytics
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dentaire App',
      theme: LightThemes.lightTheme1,
      darkTheme: DarkThemes.darkTheme1,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
      //HomeScreenStudent(), // Ou HomeScreenTeacher(), HomeScreenAdmin()
      navigatorObservers: [observer], // Ajout de l'observateur de navigation
      // Routes "simples" sans arguments
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
