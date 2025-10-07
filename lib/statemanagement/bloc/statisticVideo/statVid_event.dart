abstract class StatisticEvent {}

// Déclenche le chargement des statistiques pour une vidéo.
class LoadStatistic extends StatisticEvent {
  final String videoId;
  LoadStatistic(this.videoId);
}
