import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/Commentaire.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupère les commentaires pour une vidéo donnée.
  Stream<List<Comment>> getCommentsByVideoId(String videoId) {
    return _firestore
        .collection('comments')
        .where('videoId', isEqualTo: videoId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      // Correction: La mauvaise accolade est enlevée et la syntaxe est corrigée.
      // On utilise 'fromFirestore' pour convertir le document en un objet Comment.
      return snapshot.docs
          .map((doc) =>
              Comment.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Ajoute un nouveau commentaire.
  Future<void> addComment(Comment comment) async {
    await _firestore.collection('comments').add(comment.toMap());
  }

  // Supprime un commentaire existant.
  Future<void> deleteComment(String commentId) async {
    await _firestore.collection('comments').doc(commentId).delete();
  }
}
