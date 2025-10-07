import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/screens/admin_screens/widgets/AdminScaffold.dart';

class TeacherDetailPage extends StatelessWidget {
  final String teacherName;
  final String email;
  final String specialite;

  const TeacherDetailPage({
    super.key,
    required this.teacherName,
    required this.email,
    required this.specialite,
  });

  // Fonction utilitaire pour formater les messages d'erreur de permission
  String _formatError(Object? error) {
    String errorString = error.toString();
    if (errorString.contains('PERMISSION_DENIED')) {
      return "Erreur de permission Firestore. Vérifiez les règles de lecture de la collection 'Videos'.";
    }
    return "Erreur de chargement : $errorString";
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {"icon": Icons.comment, "title": "Nouvelle évaluation disponible"},
      {"icon": Icons.video_call, "title": "Nouvelle vidéo ajoutée"},
    ];

    return AdminScaffold(
      title: "Détails de $teacherName",
      notifications: notifications,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Infos Enseignant
            _buildInfoCard(
                Icons.person, "Nom", teacherName, Colors.green.shade700),
            _buildInfoCard(Icons.email, "Email", email, Colors.blue.shade700),
            _buildInfoCard(Icons.library_books, "Spécialité", specialite,
                Colors.purple.shade700),

            const SizedBox(height: 24),
            const Text(
              "📌 Liste des vidéos associées :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1A6175),
              ),
            ),
            const Divider(color: Color(0xFF1A6175)),

            /// 🔹 On récupère les vidéos liées à cet enseignant
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Videos")
                    .where("teacherEmail", isEqualTo: email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text(_formatError(snapshot.error),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red)));
                  }

                  final videos = snapshot.data!.docs;

                  if (videos.isEmpty) {
                    return Center(
                        child: Text("Aucune vidéo trouvée pour $teacherName."));
                  }

                  return ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video =
                          videos[index].data() as Map<String, dynamic>;
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.play_circle_fill,
                              color: Colors.orange, size: 30),
                          title: Text(video["title"] ?? "Sans titre"),
                          subtitle:
                              Text("Module: ${video["module"] ?? "Inconnu"}"),
                          onTap: () {
                            // TODO : Navigation vers VideoDetailPage avec les infos
                            // Par exemple: Navigator.push(context, MaterialPageRoute(builder: (_) => VideoDetailPage(video: video)));
                            print(
                                "Voir détail de la vidéo : ${video["title"]}");
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // AJOUT DU FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A6175),
        onPressed: () {
          // TODO : Naviguer vers la page d'ajout de vidéo en pré-remplissant l'email de l'enseignant
          // Par exemple: Navigator.push(context, MaterialPageRoute(builder: (_) => AddVideoPage(teacherEmail: email)));
          print("Ajouter une nouvelle vidéo pour l'enseignant: $teacherName");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'TODO: Ouvrir la page d\'ajout de vidéo pour $teacherName')),
          );
        },
        child: const Icon(Icons.add_to_photos, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoCard(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$label :",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
