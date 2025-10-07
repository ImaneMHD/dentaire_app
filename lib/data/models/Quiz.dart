import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/videoWithQuiz.dart';

class Quiz {
  final String id;
  final String videoId;
  final List<QuizQuestion> questions;
  final Timestamp createdAt;

  Quiz({
    required this.id,
    required this.videoId,
    required this.questions,
    required this.createdAt,
  });

  // Factory constructor to create a Quiz from a Firestore DocumentSnapshot
  factory Quiz.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Quiz(
      id: doc.id,
      videoId: data['videoId'] ?? '',
      questions: (data['questions'] as List<dynamic>?)
              ?.map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
