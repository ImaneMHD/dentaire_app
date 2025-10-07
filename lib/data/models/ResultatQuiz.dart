import 'package:cloud_firestore/cloud_firestore.dart';

class QuizResult {
  final String id;
  final String videoId;
  final String userId;
  final int score;
  final Timestamp createdAt;

  QuizResult({
    required this.id,
    required this.videoId,
    required this.userId,
    required this.score,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  factory QuizResult.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizResult(
      id: doc.id,
      videoId: data['videoId'] ?? '',
      userId: data['userId'] ?? '',
      score: data['score'] ?? 0,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'videoId': videoId,
      'userId': userId,
      'score': score,
      'createdAt': createdAt,
    };
  }
}
