import 'package:dentaire/data/models/ResultatQuiz.dart';
import 'package:equatable/equatable.dart';
import 'package:dentaire/data/models/videoWithQuiz.dart';

abstract class VideoQuizEvent extends Equatable {
  const VideoQuizEvent();

  @override
  List<Object> get props => [];
}

// Événement pour charger la liste des vidéos avec leurs quiz.
class LoadVideos extends VideoQuizEvent {}

// Événement pour démarrer un quiz pour une vidéo spécifique.
class StartQuiz extends VideoQuizEvent {
  final VideoWithQuiz video;
  const StartQuiz(this.video);

  @override
  List<Object> get props => [video];
}

// Événement pour l'étudiant qui répond à une question.
class SubmitAnswer extends VideoQuizEvent {
  final int selectedAnswerIndex;
  const SubmitAnswer(this.selectedAnswerIndex);

  @override
  List<Object> get props => [selectedAnswerIndex];
}

// Événement pour soumettre le résultat final du quiz.
class SubmitQuizResult extends VideoQuizEvent {
  final QuizResult result;
  const SubmitQuizResult(this.result);

  @override
  List<Object> get props => [result];
}

// Événement pour revenir à la liste des vidéos.
class GoBackToVideos extends VideoQuizEvent {}
