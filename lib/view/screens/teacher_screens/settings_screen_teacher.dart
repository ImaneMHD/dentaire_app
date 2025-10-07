import 'package:dentaire/view/screens/teacher_screens/BaseScaffold.dart';
import 'package:dentaire/view/screens/teacher_screens/SettingSection.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/teacher_screens/widgets/SettingTile.dart';

class SettingsScreenTeacher extends StatefulWidget {
  const SettingsScreenTeacher({super.key});

  @override
  State<SettingsScreenTeacher> createState() => _SettingsScreenTeacherState();
}

class _SettingsScreenTeacherState extends State<SettingsScreenTeacher> {
  String _currentLang = "Français"; // valeur affichée

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
            // 🔹 Header
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

            // 🔹 Contenu
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
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/profile-edit-teacher',
                            arguments: {
                              'name': 'Dr. Ahmed',
                              'email': 'ahmed@univ-dz.dz',
                            },
                          );
                        },
                      ),
                      SettingTile(
                        icon: Icons.lock,
                        title: 'Modifier mot de passe',
                        onTap: () => _showPasswordDialog(context),
                      ),
                      SettingTile(
                        icon: Icons.language,
                        title: 'Langue ($_currentLang)',
                        onTap: () async {
                          final selected =
                              await Navigator.pushNamed(context, '/language');
                          if (selected != null) {
                            setState(() {
                              _currentLang =
                                  selected == "fr" ? "Français" : "Anglais";
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SettingSection(
                    title: 'Gestion pédagogique',
                    children: [
                      SettingTile(
                        icon: Icons.video_library,
                        title: 'Gérer mes vidéos',
                        onTap: () =>
                            Navigator.pushNamed(context, '/video-list-teacher'),
                      ),
                      SettingTile(
                        icon: Icons.video_library,
                        title: 'Liste des favoris',
                        onTap: () => Navigator.pushNamed(context, '/favorites'),
                      ),
                      SettingTile(
                        icon: Icons.bar_chart,
                        title: 'Statistiques des étudiants',
                        onTap: () =>
                            Navigator.pushNamed(context, '/teacher-stats'),
                      ),
                    ],
                  ),
                  SettingSection(
                    title: 'Application',
                    children: [
                      SettingTile(
                        icon: Icons.star_rate,
                        title: 'Évaluer l\'application',
                        onTap: () => _showEvaluationDialog(context),
                      ),
                    ],
                  ),
                  SettingSection(
                    title: 'Général',
                    children: [
                      SettingTile(
                        icon: Icons.privacy_tip,
                        title: 'Confidentialité',
                        onTap: () => Navigator.pushNamed(context, '/privacy'),
                      ),
                      SettingTile(
                        icon: Icons.info,
                        title: 'À propos',
                        onTap: () => Navigator.pushNamed(context, '/about'),
                      ),
                      SettingTile(
                        icon: Icons.description,
                        title: 'Conditions',
                        onTap: () => Navigator.pushNamed(context, '/terms'),
                      ),
                      SettingTile(
                        icon: Icons.support_agent,
                        title: 'Contactez-nous',
                        onTap: () => Navigator.pushNamed(context, '/contact'),
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

  // 🔹 Dialogue pour changer mot de passe
  void _showPasswordDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Voulez-vous changer votre mot de passe ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(ctx, '/password-change');
            },
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler"),
          ),
        ],
      ),
    );
  }
}
