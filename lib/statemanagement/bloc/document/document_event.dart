import 'package:dentaire/data/models/Documents.dart';

abstract class DocumentEvent {}

// Événement pour charger les documents.
class LoadDocuments extends DocumentEvent {}

// Événement pour ajouter un nouveau document.
class AddDocument extends DocumentEvent {
  final VideoDocument document;
  AddDocument(this.document);
}

// Événement pour supprimer un document.
class DeleteDocument extends DocumentEvent {
  final String documentId;
  DeleteDocument(this.documentId);
}
