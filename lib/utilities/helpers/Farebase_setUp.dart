import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:dentaire/firebase_options.dart';

class FirebaseSetup {
  static Future<void> initialize() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.web,
      );
    } else {
      // Pour les applications mobiles ou de bureau, vous devez
      // utiliser la configuration par défaut.
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }
}
