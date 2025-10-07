// terms_screen.dart
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditions'),
        backgroundColor: const Color(0xFF1A6175),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            "Conditions générales d'utilisation de l'application :\n\n"
            "1. L'utilisateur s'engage à utiliser l'application de manière responsable.\n"
            "2. Le contenu pédagogique est fourni à titre informatif...\n"
            "3. Les données personnelles seront protégées conformément à la loi...\n"
            "...",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
