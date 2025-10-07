import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/ResultatQuiz.dart';
import 'package:dentaire/data/models/videoWithQuiz.dart';

class VideoQuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Récupère toutes les vidéos avec leurs quiz associés.
  Stream<List<VideoWithQuiz>> getVideosWithQuizzes() {
    return _db.collection('videos').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => VideoWithQuiz.fromFirestore(doc)).toList());
  }

  // Soumet un résultat de quiz à la base de données.
  Future<void> submitQuizResult(QuizResult result) async {
    try {
      await _db.collection('quiz_results').add(result.toFirestore());
      print('Résultat du quiz soumis avec succès.');
    } catch (e) {
      throw Exception('Erreur lors de la soumission du résultat : $e');
    }
  }

  // Récupère les résultats de quiz pour une vidéo spécifique.
  Stream<List<QuizResult>> getQuizResultsForVideo(String videoId) {
    return _db
        .collection('quiz_results')
        .where('videoId', isEqualTo: videoId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => QuizResult.fromFirestore(doc)).toList());
  }

  // Ajout d'une nouvelle vidéo avec son quiz.
  Future<void> addVideoWithQuiz(VideoWithQuiz video) async {
    try {
      await _db.collection('videos').add(video.toFirestore());
      print('Vidéo et quiz ajoutés avec succès.');
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la vidéo et du quiz : $e');
    }
  }

  // Met à jour une vidéo existante.
  Future<void> updateVideoWithQuiz(
      String videoId, Map<String, dynamic> data) async {
    try {
      await _db.collection('videos').doc(videoId).update(data);
      print('Vidéo mise à jour avec succès.');
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la vidéo : $e');
    }
  }

  // Supprime une vidéo.
  Future<void> deleteVideo(String videoId) async {
    try {
      await _db.collection('videos').doc(videoId).delete();
      print('Vidéo supprimée avec succès.');
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la vidéo : $e');
    }
  }
}
