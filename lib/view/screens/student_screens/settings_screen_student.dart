import 'package:dentaire/view/screens/admin_screens/AboutScreen.dart';
import 'package:dentaire/view/screens/admin_screens/ContactScreen.dart';
import 'package:dentaire/view/screens/admin_screens/TermScreen.dart';
import 'package:dentaire/view/screens/common_screens/evaluation_screen.dart';
import 'package:dentaire/view/screens/common_screens/langue.dart';
import 'package:dentaire/view/screens/common_screens/modifite_mot_de_passe.dart';
import 'package:flutter/material.dart';
import 'BaseScaffold.dart';
import 'SettingSection.dart';
import 'widgets/SettingTile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: '',
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F9CB2), Color(0xff065464)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 🔹 Custom Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Paramètres",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),

            // 🔽 Main Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SettingSection(
                    title: 'Compte',
                    children: [
                      SettingTile(
                        icon: Icons.person,
                        title: 'Modifier profil',
                        onTap: () =>
                            Navigator.pushNamed(context, '/profile-edit'),
                      ),
                      SettingTile(
                        icon: Icons.lock,
                        title: 'Modifier mot de passe',
                        onTap: () => showPasswordChangeDialog(context),
                      ),
                      SettingTile(
                        icon: Icons.language,
                        title: 'Langue',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LanguageScreen()),
                        ),
                      ),
                    ],
                  ),
                  SettingSection(
                    title: 'Application',
                    children: [
                      SettingTile(
                        icon: Icons.star_rate,
                        title: 'Évaluer l\'application',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EvaluationAppScreen()),
                        ),
                      ),
                    ],
                  ),
                  SettingSection(
                    title: 'Général',
                    children: [
                      SettingTile(
                        icon: Icons.lock,
                        title: 'Confidentialité',
                        onTap: () => Navigator.pushNamed(context, '/privacy'),
                      ),
                      SettingTile(
                        icon: Icons.info,
                        title: 'À propos',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AboutScreen()),
                        ),
                      ),
                      SettingTile(
                        icon: Icons.description,
                        title: 'Conditions',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TermsScreen()),
                        ),
                      ),
                      SettingTile(
                        icon: Icons.support_agent,
                        title: 'Contactez-nous',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ContactScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🛠️ Dialogues
  void _showLanguageDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: const Text('Sélecteur de langue ici'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showEvaluationDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Évaluer l\'application'),
        content: const Text('Fonctionnalité d\'évaluation ici'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
