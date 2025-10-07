import 'package:equatable/equatable.dart';
import 'package:dentaire/data/models/videoWithQuiz.dart';

abstract class VideoQuizState extends Equatable {
  const VideoQuizState();

  @override
  List<Object?> get props => [];
}

// État initial.
class VideoQuizInitial extends VideoQuizState {}

// État de chargement des données.
class VideoQuizLoading extends VideoQuizState {}

// État lorsque la liste des vidéos est chargée.
class VideosLoaded extends VideoQuizState {
  final List<VideoWithQuiz> videos;
  const VideosLoaded(this.videos);

  @override
  List<Object?> get props => [videos];
}

// État du quiz en cours de l'étudiant.
class QuizInProgress extends VideoQuizState {
  final VideoWithQuiz currentVideo;
  final int currentQuestionIndex;
  final int score;
  final bool isAnswered;
  final int? selectedAnswerIndex;

  const QuizInProgress({
    required this.currentVideo,
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.isAnswered = false,
    this.selectedAnswerIndex,
  });

  QuizInProgress copyWith({
    VideoWithQuiz? currentVideo,
    int? currentQuestionIndex,
    int? score,
    bool? isAnswered,
    int? selectedAnswerIndex,
  }) {
    return QuizInProgress(
      currentVideo: currentVideo ?? this.currentVideo,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedAnswerIndex: selectedAnswerIndex ?? this.selectedAnswerIndex,
    );
  }

  @override
  List<Object?> get props => [
        currentVideo,
        currentQuestionIndex,
        score,
        isAnswered,
        selectedAnswerIndex,
      ];
}

// État lorsque le quiz est terminé et le résultat est prêt à être soumis.
class QuizFinished extends VideoQuizState {
  final VideoWithQuiz video;
  final int finalScore;
  final int totalQuestions;
  const QuizFinished({
    required this.video,
    required this.finalScore,
    required this.totalQuestions,
  });

  @override
  List<Object?> get props => [video, finalScore, totalQuestions];
}

// État en cas d'erreur.
class VideoQuizError extends VideoQuizState {
  final String message;
  const VideoQuizError(this.message);

  @override
  List<Object?> get props => [message];
}
