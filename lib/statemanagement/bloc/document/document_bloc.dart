import 'package:bloc/bloc.dart';
import 'package:dentaire/statemanagement/bloc/document/document_event.dart';
import 'package:dentaire/statemanagement/bloc/document/document_service.dart';
import 'package:dentaire/statemanagement/bloc/document/document_state.dart';
import 'dart:async';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentService _documentService;
  StreamSubscription? _documentsSubscription;

  DocumentBloc(this._documentService) : super(DocumentInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<AddDocument>(_onAddDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  // Gère l'événement de chargement des documents.
  Future<void> _onLoadDocuments(
      LoadDocuments event, Emitter<DocumentState> emit) async {
    emit(DocumentLoading());
    // Annule la souscription précédente pour éviter les fuites de mémoire.
    await _documentsSubscription?.cancel();
    _documentsSubscription = _documentService.getDocuments().listen(
      (documents) {
        emit(DocumentsLoaded(documents));
      },
      onError: (e) {
        emit(DocumentError('Erreur de chargement des documents: $e'));
      },
    );
  }

  // Gère l'événement d'ajout d'un document.
  Future<void> _onAddDocument(
      AddDocument event, Emitter<DocumentState> emit) async {
    try {
      await _documentService.addDocument(event.document);
    } catch (e) {
      emit(DocumentError('Erreur d\'ajout du document: $e'));
    }
  }

  // Gère l'événement de suppression d'un document.
  Future<void> _onDeleteDocument(
      DeleteDocument event, Emitter<DocumentState> emit) async {
    try {
      await _documentService.deleteDocument(event.documentId);
    } catch (e) {
      emit(DocumentError('Erreur de suppression du document: $e'));
    }
  }

  // Nettoie la souscription lors de la fermeture du BLoC.
  @override
  Future<void> close() {
    _documentsSubscription?.cancel();
    return super.close();
  }
}
