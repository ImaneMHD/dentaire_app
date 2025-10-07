import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/StatistiqueVideos.dart';

class StatisticService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Écoute les statistiques d'une vidéo en temps réel.
  Stream<Statistic?> getStatisticByVideoId(String videoId) {
    // Les statistiques sont stockées dans une collection 'statistics'
    // où le documentId est égal au videoId.
    return _firestore.collection('statistics').doc(videoId).snapshots().map(
      (doc) {
        if (doc.exists) {
          // Crée un objet Statistic si le document existe
          return Statistic.fromMap(doc.data() as Map<String, dynamic>);
        } else {
          // Retourne null si le document n'existe pas
          return null;
        }
      },
    );
  }
}
