import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Récupère les statistiques globales
  Future<Map<String, dynamic>> fetchStats() async {
    final enseignants = await _db
        .collection("Users")
        .where("role", isEqualTo: "enseignant")
        .get();
    final etudiants = await _db
        .collection("Users")
        .where("role", isEqualTo: "etudiant")
        .get();
    final videos = await _db.collection("videos").get();
    final quiz = await _db.collection("quiz").get();

    return {
      "enseignants": enseignants.docs.length,
      "etudiants": etudiants.docs.length,
      "videos": videos.docs.length,
      "quiz": quiz.docs.length,
    };
  }

  /// Récupère les vidéos récentes
  Future<List<Map<String, dynamic>>> fetchRecentVideos() async {
    final snapshot = await _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(5)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
