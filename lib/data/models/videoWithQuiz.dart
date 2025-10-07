import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> data) {
    return QuizQuestion(
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctOptionIndex: data['correctOptionIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }
}

class VideoWithQuiz {
  final String id;
  final String title;
  final String module;
  final String description;
  final List<String> files;
  final List<QuizQuestion> quiz;
  final String videoUrl;
  final Timestamp createdAt;
  final String? teacherId; // facultatif si tu veux lier à l'enseignant

  VideoWithQuiz({
    required this.id,
    required this.title,
    required this.module,
    required this.description,
    required this.files,
    required this.quiz,
    required this.videoUrl,
    this.teacherId,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  /// Récupération depuis Firestore
  factory VideoWithQuiz.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VideoWithQuiz(
      id: doc.id,
      title: data['title'] ?? '',
      module: data['module'] ?? '',
      description: data['description'] ?? '',
      files: List<String>.from(data['files'] ?? []),
      quiz: (data['quiz'] as List<dynamic>? ?? [])
          .map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>))
          .toList(),
      videoUrl: data['videoUrl'] ?? '',
      teacherId: data['teacherId'], // utile si stocké
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  /// Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'module': module,
      'description': description,
      'files': files,
      'quiz': quiz.map((q) => q.toMap()).toList(),
      'videoUrl': videoUrl,
      'teacherId': teacherId,
      'createdAt': createdAt,
    };
  }

  /// copyWith pratique pour mise à jour
  VideoWithQuiz copyWith({
    String? title,
    String? module,
    String? description,
    List<String>? files,
    List<QuizQuestion>? quiz,
    String? videoUrl,
    String? teacherId,
    Timestamp? createdAt,
  }) {
    return VideoWithQuiz(
      id: id,
      title: title ?? this.title,
      module: module ?? this.module,
      description: description ?? this.description,
      files: files ?? this.files,
      quiz: quiz ?? this.quiz,
      videoUrl: videoUrl ?? this.videoUrl,
      teacherId: teacherId ?? this.teacherId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
