import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
        backgroundColor: const Color(0xFF1A6175),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "À propos de l'application",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                  "Cette application est conçue pour aider les étudiants en médecine dentaire à suivre des cours, visionner des vidéos pédagogiques et passer des quiz interactifs."),
              SizedBox(height: 12),
              Text(
                "Équipe de développement :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(" - Ibrahim, Développement Flutter"),
              Text(" - Ahmed, Back-end et base de données"),
              Text(" - Le reste de l'équipe pédagogique..."),
            ],
          ),
        ),
      ),
    );
  }
}
