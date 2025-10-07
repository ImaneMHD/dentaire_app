import 'package:dentaire/data/models/Commentaire.dart';

abstract class CommentEvent {}

// Charge les commentaires pour une vidéo.
class LoadComments extends CommentEvent {
  final String videoId;
  LoadComments(this.videoId);
}

// Ajoute un nouveau commentaire.
class AddComment extends CommentEvent {
  final Comment comment;
  AddComment(this.comment);
}

// Supprime un commentaire.
class DeleteComment extends CommentEvent {
  final String commentId;
  DeleteComment(this.commentId);
}
