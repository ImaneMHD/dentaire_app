import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/Documents.dart';

class DocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupère la liste de tous les documents vidéo.
  Stream<List<VideoDocument>> getDocuments() {
    return _firestore
        .collection('documents')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => VideoDocument.fromFirestore(doc))
          .toList();
    });
  }

  // Ajoute un nouveau document vidéo à Firestore.
  Future<void> addDocument(VideoDocument document) async {
    await _firestore.collection('documents').add(document.toFirestore());
  }

  // Supprime un document vidéo existant.
  Future<void> deleteDocument(String documentId) async {
    await _firestore.collection('documents').doc(documentId).delete();
  }
}
