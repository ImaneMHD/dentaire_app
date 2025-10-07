import 'package:cloud_firestore/cloud_firestore.dart';

class VideoDocument {
  final String id;
  final String videoId;
  final String title;
  final String fileUrl;
  final String fileType;
  final Timestamp createdAt;

  VideoDocument({
    required this.id,
    required this.videoId,
    required this.title,
    required this.fileUrl,
    required this.fileType,
    required this.createdAt,
  });

  /// Crée une instance de VideoDocument à partir d'un DocumentSnapshot Firestore.
  factory VideoDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoDocument(
      id: doc.id,
      videoId: data['videoId'] ?? '',
      title: data['title'] ?? 'Titre inconnu',
      fileUrl: data['fileUrl'] ?? '',
      fileType: data['fileType'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  /// Convertit l'instance en Map pour l'enregistrement dans Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'videoId': videoId,
      'title': title,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'createdAt': createdAt,
    };
  }
}
