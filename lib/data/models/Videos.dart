import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String videoUrl;
  final int likes;
  final int views;
  final int favorites;
  final int comments;
  final Timestamp createdAt;

  const Video({
    this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
    this.favorites = 0,
    this.comments = 0,
    required this.createdAt,
  });

  // Creates a Video instance from a Firestore DocumentSnapshot.
  factory Video.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Video(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      videoUrl: data['videoUrl'] as String? ?? '',
      likes: data['likes'] as int? ?? 0,
      views: data['views'] as int? ?? 0,
      favorites: data['favorites'] as int? ?? 0,
      comments: data['comments'] as int? ?? 0,
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  // Converts a Video instance to a Map for storage in Firestore.
  // The method name is changed to `toFirestore` to match the service call.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'likes': likes,
      'views': views,
      'favorites': favorites,
      'comments': comments,
      'createdAt': createdAt,
    };
  }

  // Utility method for creating a new instance with updated values.
  Video copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    int? likes,
    int? views,
    int? favorites,
    int? comments,
    Timestamp? createdAt,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      favorites: favorites ?? this.favorites,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        videoUrl,
        likes,
        views,
        favorites,
        comments,
        createdAt,
      ];
}
