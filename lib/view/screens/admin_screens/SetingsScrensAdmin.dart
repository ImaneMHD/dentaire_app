import 'package:dentaire/view/screens/admin_screens/AboutScreen.dart';
import 'package:dentaire/view/screens/admin_screens/AdminProfilePage.dart';
import 'package:dentaire/view/screens/admin_screens/ContactScreen.dart';
import 'package:dentaire/view/screens/admin_screens/OtionScreansAdmin.dart';
import 'package:dentaire/view/screens/admin_screens/TermScreen.dart';
import 'package:dentaire/view/screens/admin_screens/UsersPage.dart';
import 'package:dentaire/view/screens/common_screens/profile_screen.dart';
import 'package:dentaire/view/screens/common_screens/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/admin_screens/add_teacher_screen.dart';
import 'package:dentaire/view/screens/admin_screens/SetingSectionAdmin.dart';
import 'package:dentaire/view/screens/admin_screens/widgets/settingsTileAdmin.dart';
import 'package:dentaire/view/screens/admin_screens/widgets/AdminScaffold.dart';

class SettingsScreenAdmin extends StatefulWidget {
  const SettingsScreenAdmin({super.key});

  @override
  State<SettingsScreenAdmin> createState() => _SettingsScreenAdminState();
}

class _SettingsScreenAdminState extends State<SettingsScreenAdmin> {
  String _currentLang = "Français";

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {"icon": Icons.person_add, "title": "Nouvel utilisateur ajouté"},
      {"icon": Icons.video_call, "title": "Nouvelle vidéo ajoutée"},
    ];

    return AdminScaffold(
      title: "Paramètres",
      notifications: notifications,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F9CB2), Color(0xff065464)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🔹 Compte
            SettingSection(
              title: 'Compte',
              children: [
                SettingTile(
                  icon: Icons.person,
                  title: 'Voir  profil',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminProfilePage(),
                    ),
                  ),
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

            // 🔹 Gestion des utilisateurs
            SettingSection(
              title: 'Gestion des utilisateurs',
              children: [
                SettingTile(
                  icon: Icons.person_add,
                  title: 'Ajouter un enseignant',
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddTeacherPage()),
                    );
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Enseignant ${result["name"]} ajouté avec succès !'),
                        ),
                      );
                    }
                  },
                ),
                SettingTile(
                  icon: Icons.people,
                  title: 'Liste des utilisateurs',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UsersPage(),
                    ),
                  ),
                ),
              ],
            ),

            // 🔹 Application
            SettingSection(
              title: 'Application',
              children: [
                SettingTile(
                  icon: Icons.star_rate,
                  title: 'Évaluer l\'application',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminOptionScreen(
                        title: 'Évaluer l\'application',
                        description: 'Fonctionnalité d\'évaluation ici.',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 🔹 Général
            SettingSection(
              title: 'Général',
              children: [
                SettingTile(
                  icon: Icons.privacy_tip,
                  title: 'Confidentialité',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminOptionScreen(
                              title: 'Confidentialité',
                              description:
                                  'Ici tu peux voir la politique de confidentialité.',
                            )),
                  ),
                ),
                SettingTile(
                  icon: Icons.info,
                  title: 'À propos',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  ),
                ),
                SettingTile(
                  icon: Icons.description,
                  title: 'Conditions',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TermsScreen()),
                  ),
                ),
                SettingTile(
                  icon: Icons.support_agent,
                  title: 'Contactez-nous',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Dialogue mot de passe (Mise à jour pour utiliser Navigator.push)
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
              // Navigue directement vers la page de changement de mot de passe
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (_) => const PasswordChangeScreen(),
                ),
              );
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
