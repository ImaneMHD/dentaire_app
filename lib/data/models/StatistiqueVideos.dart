class Statistic {
  final String videoId;
  final int views;
  final int likes;
  final int comments;
  final int favorites;

  Statistic({
    required this.videoId,
    required this.views,
    required this.likes,
    required this.comments,
    required this.favorites,
  });

  factory Statistic.fromMap(Map<String, dynamic> data) {
    return Statistic(
      videoId: data['videoId'] ?? '',
      views: data['views'] ?? 0,
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      favorites: data['favorites'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'views': views,
      'likes': likes,
      'comments': comments,
      'favorites': favorites,
    };
  }
}
