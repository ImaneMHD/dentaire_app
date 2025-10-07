import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/favorites.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupère la liste des favoris pour un étudiant donné.
  Stream<List<Favorite>> getFavoritesByStudentId(String studentId) {
    return _firestore
        .collection('favorites')
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Favorite.fromFirestore(doc)).toList();
    });
  }

  // Ajoute une vidéo aux favoris.
  Future<void> addFavorite(Favorite favorite) async {
    await _firestore.collection('favorites').add(favorite.toFirestore());
  }

  // Supprime une vidéo des favoris.
  Future<void> deleteFavorite(String favoriteId) async {
    await _firestore.collection('favorites').doc(favoriteId).delete();
  }
}
