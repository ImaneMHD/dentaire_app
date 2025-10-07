import 'package:dentaire/data/models/StatistiqueVideos.dart';

abstract class StatisticState {}

class StatisticInitial extends StatisticState {}

class StatisticLoading extends StatisticState {}

class StatisticLoaded extends StatisticState {
  final Statistic statistic;
  StatisticLoaded(this.statistic);
}

class StatisticError extends StatisticState {
  final String message;
  StatisticError(this.message);
}
