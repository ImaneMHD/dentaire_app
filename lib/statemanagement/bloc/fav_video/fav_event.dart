import 'package:dentaire/data/models/favorites.dart';

abstract class FavoriteEvent {}

// Charge les favoris pour un étudiant.
class LoadFavorites extends FavoriteEvent {
  final String studentId;
  LoadFavorites(this.studentId);
}

// Ajoute une vidéo aux favoris.
class AddFavorite extends FavoriteEvent {
  final Favorite favorite;
  AddFavorite(this.favorite);
}

// Supprime une vidéo des favoris.
class DeleteFavorite extends FavoriteEvent {
  final String favoriteId;
  DeleteFavorite(this.favoriteId);
}
