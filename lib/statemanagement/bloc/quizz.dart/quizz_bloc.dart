import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dentaire/statemanagement/bloc/quizz.dart/quizz_event.dart';
import 'package:dentaire/statemanagement/bloc/quizz.dart/quizz_service.dart';
import 'package:dentaire/statemanagement/bloc/quizz.dart/quizz_state.dart';

class VideoQuizBloc extends Bloc<VideoQuizEvent, VideoQuizState> {
  final VideoQuizService _firestoreService;
  StreamSubscription? _videosSubscription;

  VideoQuizBloc(this._firestoreService) : super(VideoQuizInitial()) {
    on<LoadVideos>(_onLoadVideos);
    on<StartQuiz>(_onStartQuiz);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<GoBackToVideos>(_onGoBackToVideos);
    on<SubmitQuizResult>(_onSubmitQuizResult);
  }

  void _onLoadVideos(LoadVideos event, Emitter<VideoQuizState> emit) {
    emit(VideoQuizLoading());
    _videosSubscription?.cancel();
    _videosSubscription = _firestoreService.getVideosWithQuizzes().listen(
      (videos) {
        emit(VideosLoaded(videos));
      },
      onError: (e) {
        emit(VideoQuizError('Erreur de chargement des vidéos: $e'));
      },
    );
  }

  void _onStartQuiz(StartQuiz event, Emitter<VideoQuizState> emit) {
    emit(QuizInProgress(currentVideo: event.video));
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<VideoQuizState> emit) async {
    if (state is QuizInProgress) {
      final currentState = state as QuizInProgress;
      final quizQuestions = currentState.currentVideo.quiz;

      if (currentState.currentQuestionIndex >= quizQuestions.length) {
        return;
      }

      final currentQuestion = quizQuestions[currentState.currentQuestionIndex];
      final isCorrect =
          event.selectedAnswerIndex == currentQuestion.correctOptionIndex;
      final newScore = currentState.score + (isCorrect ? 1 : 0);

      emit(currentState.copyWith(
        isAnswered: true,
        selectedAnswerIndex: event.selectedAnswerIndex,
        score: newScore,
      ));

      await Future.delayed(const Duration(milliseconds: 1500));

      final nextQuestionIndex = currentState.currentQuestionIndex + 1;
      if (nextQuestionIndex < quizQuestions.length) {
        emit(currentState.copyWith(
          currentQuestionIndex: nextQuestionIndex,
          isAnswered: false,
          selectedAnswerIndex: null,
        ));
      } else {
        emit(QuizFinished(
          video: currentState.currentVideo,
          finalScore: newScore,
          totalQuestions: quizQuestions.length,
        ));
      }
    }
  }

  void _onSubmitQuizResult(
      SubmitQuizResult event, Emitter<VideoQuizState> emit) async {
    emit(VideoQuizLoading());
    try {
      await _firestoreService.submitQuizResult(event.result);
      emit(const VideoQuizError('Résultat soumis avec succès !'));
      emit(VideosLoaded(const []));
    } catch (e) {
      emit(VideoQuizError('Échec de la soumission du résultat: $e'));
    }
  }

  void _onGoBackToVideos(GoBackToVideos event, Emitter<VideoQuizState> emit) {
    add(LoadVideos());
  }

  @override
  Future<void> close() {
    _videosSubscription?.cancel();
    return super.close();
  }
}
