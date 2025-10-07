import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dentaire/statemanagement/bloc/comments/comment_event.dart';
import 'package:dentaire/statemanagement/bloc/comments/comment_service.dart';
import 'package:dentaire/statemanagement/bloc/comments/comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentService _commentService;
  StreamSubscription? _commentsSubscription;

  CommentBloc(this._commentService) : super(CommentInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
  }

  // Gère l'événement de chargement des commentaires.
  Future<void> _onLoadComments(
      LoadComments event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    await _commentsSubscription?.cancel();
    _commentsSubscription =
        _commentService.getCommentsByVideoId(event.videoId).listen(
      (comments) {
        emit(CommentsLoaded(comments));
      },
      onError: (e) {
        emit(CommentError('Erreur de chargement des commentaires: $e'));
      },
    );
  }

  // Gère l'événement d'ajout d'un commentaire.
  Future<void> _onAddComment(
      AddComment event, Emitter<CommentState> emit) async {
    try {
      await _commentService.addComment(event.comment);
    } catch (e) {
      emit(CommentError('Erreur d\'ajout du commentaire: $e'));
    }
  }

  // Gère l'événement de suppression d'un commentaire.
  Future<void> _onDeleteComment(
      DeleteComment event, Emitter<CommentState> emit) async {
    try {
      await _commentService.deleteComment(event.commentId);
    } catch (e) {
      emit(CommentError('Erreur de suppression du commentaire: $e'));
    }
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }
}
