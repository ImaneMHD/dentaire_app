import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dentaire/statemanagement/bloc/fav_video/fav_event.dart';
import 'package:dentaire/statemanagement/bloc/fav_video/fav_service.dart';
import 'package:dentaire/statemanagement/bloc/fav_video/fav_video_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteService _favoriteService;
  StreamSubscription? _favoritesSubscription;

  FavoriteBloc(this._favoriteService) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<DeleteFavorite>(_onDeleteFavorite);
  }

  // Gère le chargement des favoris pour un étudiant.
  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    await _favoritesSubscription?.cancel();
    _favoritesSubscription =
        _favoriteService.getFavoritesByStudentId(event.studentId).listen(
      (favorites) {
        emit(FavoritesLoaded(favorites));
      },
      onError: (e) {
        emit(FavoriteError('Erreur de chargement des favoris: $e'));
      },
    );
  }

  // Gère l'ajout d'un favori.
  Future<void> _onAddFavorite(
      AddFavorite event, Emitter<FavoriteState> emit) async {
    try {
      await _favoriteService.addFavorite(event.favorite);
      emit(FavoriteActionSuccess());
      // Optionnel: Recharger les favoris après l'ajout pour mettre à jour l'UI.
      // add(LoadFavorites(event.favorite.studentId));
    } catch (e) {
      emit(FavoriteError('Erreur d\'ajout du favori: $e'));
    }
  }

  // Gère la suppression d'un favori.
  Future<void> _onDeleteFavorite(
      DeleteFavorite event, Emitter<FavoriteState> emit) async {
    try {
      await _favoriteService.deleteFavorite(event.favoriteId);
      emit(FavoriteActionSuccess());
      // Optionnel: Recharger les favoris après la suppression.
      // L'écouteur Firestore devrait déjà gérer cela.
    } catch (e) {
      emit(FavoriteError('Erreur de suppression du favori: $e'));
    }
  }

  // Nettoie la souscription à la fermeture du BLoC.
  @override
  Future<void> close() {
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
