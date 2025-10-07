import 'package:dentaire/data/models/Commentaire.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final List<Comment> comments;
  CommentsLoaded(this.comments);
}

class CommentError extends CommentState {
  final String message;
  CommentError(this.message);
}
