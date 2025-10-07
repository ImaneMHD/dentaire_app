import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/VideoWithQuiz.dart';

class VideoService {
  final FirebaseFirestore _firestore;

  VideoService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _videosCollectionPath = 'videos';

  /// 🔹 Récupérer les vidéos avec leurs quiz
  Stream<List<VideoWithQuiz>> getVideos() {
    return _firestore
        .collection(_videosCollectionPath)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => VideoWithQuiz.fromFirestore(doc))
          .toList();
    });
  }

  /// 🔹 Ajouter une nouvelle vidéo
  Future<void> addVideo(VideoWithQuiz video) {
    return _firestore
        .collection(_videosCollectionPath)
        .add(video.toFirestore());
  }

  /// 🔹 Mettre à jour une vidéo
  Future<void> updateVideo(VideoWithQuiz video) {
    if (video.id.isEmpty) {
      throw Exception("L'ID de la vidéo est requis pour la mise à jour.");
    }
    return _firestore
        .collection(_videosCollectionPath)
        .doc(video.id)
        .update(video.toFirestore());
  }

  /// 🔹 Supprimer une vidéo
  Future<void> deleteVideo(String videoId) {
    return _firestore.collection(_videosCollectionPath).doc(videoId).delete();
  }
}
