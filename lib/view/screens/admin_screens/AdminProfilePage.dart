import 'package:dentaire/view/screens/common_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/admin_screens/widgets/AdminScaffold.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {"icon": Icons.settings, "title": "Mise à jour des paramètres"},
    ];

    return AdminScaffold(
      title: "Profil Admin",
      notifications: notifications,
      body: const ProfileScreen(), // 🔹 On réutilise ton ProfileScreen
    );
  }
}
