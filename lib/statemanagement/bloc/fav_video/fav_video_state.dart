import 'package:dentaire/data/models/favorites.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoritesLoaded extends FavoriteState {
  final List<Favorite> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoriteActionSuccess extends FavoriteState {}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
}
