import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/screens/admin_screens/widgets/AdminScaffold.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {"icon": Icons.people, "title": "Nouvel utilisateur ajouté"},
    ];

    return AdminScaffold(
      title: "Tous les Utilisateurs",
      notifications: notifications,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users") // 🔹 Assure-toi que c’est bien "Users"
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun utilisateur trouvé"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;

              String role = user["role"] ?? "inconnu";
              IconData icon;

              switch (role) {
                case "admin":
                  icon = Icons.admin_panel_settings;
                  break;
                case "teacher":
                  icon = Icons.person;
                  break;
                case "student":
                  icon = Icons.school;
                  break;
                default:
                  icon = Icons.help;
              }

              return Card(
                child: ListTile(
                  leading: Icon(icon, color: Colors.blueGrey),
                  title: Text(user["name"] ?? "Nom inconnu"),
                  subtitle: Text("📧 ${user["email"] ?? "email manquant"}\n"
                      "🎭 Rôle : $role"),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
