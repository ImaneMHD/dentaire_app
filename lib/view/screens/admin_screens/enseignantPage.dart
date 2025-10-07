import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/screens/admin_screens/DetailTeacher.dart'; // Assurez-vous que le chemin est correct
import 'package:dentaire/view/screens/admin_screens/add_teacher_screen.dart'; // Assurez-vous que le chemin est correct

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  // L'utilisation de _streamBuilderKey n'est plus nécessaire car le StreamBuilder
  // gère les mises à jour en temps réel par défaut.

  String _formatError(Object? error) {
    String errorString = error.toString();
    if (errorString.contains('PERMISSION_DENIED')) {
      return "Erreur de permission. Vérifiez vos règles Firestore et assurez-vous que l'administrateur est correctement connecté.";
    }
    return "Erreur : $errorString";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tous les Enseignants"),
        backgroundColor: const Color(0xFF1A6175),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 🔑 Point clé : Ce stream écoute en permanence la collection 'Enseignants'.
        // Tout ajout, modification ou suppression met à jour automatiquement la liste.
        stream:
            FirebaseFirestore.instance.collection("enseignants").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_formatError(snapshot.error),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
            ));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun enseignant trouvé."));
          }

          final teachers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final doc = teachers[index];
              final data = doc.data() as Map<String, dynamic>;
              final teacherId = doc
                  .id; // Récupérer l'ID pour les actions (suppression/édition)

              final teacherName = data["name"] ?? "Nom inconnu";
              final teacherEmail = data["email"] ?? "email@inconnu.com";
              final teacherSpecialite =
                  data["specialite"] ?? "Spécialité non définie";

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1A6175).withOpacity(0.1),
                    child: const Icon(Icons.school, color: Color(0xFF1A6175)),
                  ),
                  title: Text(
                    teacherName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Spécialité: $teacherSpecialite",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 14, color: Color(0xFF1A6175)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherDetailPage(
                          // Optionnel : Passer l'ID du document pour les opérations futures
                          teacherName: teacherName,
                          email: teacherEmail,
                          specialite: teacherSpecialite,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A6175),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Navigue vers la page d'ajout
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTeacherPage()),
          );

          // La ligne setState / UniqueKey a été supprimée car elle est inutile.
          // Le StreamBuilder détectera l'ajout automatiquement.
        },
      ),
    );
  }
}
