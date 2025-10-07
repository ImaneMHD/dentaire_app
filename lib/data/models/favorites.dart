import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  final String id;
  final String videoId;
  final String studentId;
  final Timestamp createdAt;

  Favorite({
    required this.id,
    required this.videoId,
    required this.studentId,
    required this.createdAt,
  });

  /// Creates a Favorite instance from a Firestore DocumentSnapshot.
  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Favorite(
      id: doc.id,
      videoId: data['videoId'] ?? '',
      studentId: data['studentId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  /// Converts the instance to a Map for saving to Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'videoId': videoId,
      'studentId': studentId,
      'createdAt': createdAt,
    };
  }
}
