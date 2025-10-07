import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GestionVideos {
  final String teacherId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<Map<String, dynamic>>> getAllVideosForTeacher() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .where('teacherId', isEqualTo: teacherId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'videoid': data['videoid'],
          'title': data['title'] ?? 'Sans titre',
          'module': data['module'] ?? 'Module inconnu',
          'views': data['views'] ?? 0,
          'files': (data['documents'] as List?)?.length ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Erreur lors du chargement des vidéos : $e');
      return [];
    }
  }
}
