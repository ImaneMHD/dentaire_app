import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dentaire/data/models/StatistiqueVideos.dart';
import 'package:dentaire/statemanagement/bloc/statisticVideo/statVid_event.dart';
import 'package:dentaire/statemanagement/bloc/statisticVideo/statVid_service.dart';
import 'package:dentaire/statemanagement/bloc/statisticVideo/statVid_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final StatisticService _statisticService;
  StreamSubscription? _statisticSubscription;

  StatisticBloc(this._statisticService) : super(StatisticInitial()) {
    on<LoadStatistic>(_onLoadStatistic);
  }

  // Gère l'événement de chargement des statistiques.
  Future<void> _onLoadStatistic(
      LoadStatistic event, Emitter<StatisticState> emit) async {
    emit(StatisticLoading());
    await _statisticSubscription?.cancel();
    _statisticSubscription =
        _statisticService.getStatisticByVideoId(event.videoId).listen(
      (statistic) {
        if (statistic != null) {
          emit(StatisticLoaded(statistic));
        } else {
          // Si aucune statistique n'est trouvée, on peut initialiser les valeurs à 0.
          emit(StatisticLoaded(
            Statistic(
              videoId: event.videoId,
              views: 0,
              likes: 0,
              comments: 0,
              favorites: 0,
            ),
          ));
        }
      },
      onError: (e) {
        emit(StatisticError('Erreur de chargement des statistiques: $e'));
      },
    );
  }

  @override
  Future<void> close() {
    _statisticSubscription?.cancel();
    return super.close();
  }
}
