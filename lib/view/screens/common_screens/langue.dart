import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLang = "fr"; // par défaut Français

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir la langue"),
        backgroundColor: const Color(0xFF065464),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sélectionnez votre langue :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🔹 Choix Français
            RadioListTile<String>(
              value: "fr",
              groupValue: _selectedLang,
              title: const Text("Français"),
              onChanged: (val) {
                setState(() {
                  _selectedLang = val!;
                });
              },
            ),

            // 🔹 Choix Anglais
            RadioListTile<String>(
              value: "en",
              groupValue: _selectedLang,
              title: const Text("English"),
              onChanged: (val) {
                setState(() {
                  _selectedLang = val!;
                });
              },
            ),

            const SizedBox(height: 30),

            // 🔹 Bouton de confirmation
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF065464),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context, _selectedLang);
                  // retourne la langue choisie
                },
                child: const Text("Valider"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
