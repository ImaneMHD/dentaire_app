import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final Map<String, dynamic>? stats;
  final List<Map<String, dynamic>> recentVideos;
  final String? error;

  const DashboardState({
    this.isLoading = false,
    this.stats,
    this.recentVideos = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    Map<String, dynamic>? stats,
    List<Map<String, dynamic>>? recentVideos,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      stats: stats ?? this.stats,
      recentVideos: recentVideos ?? this.recentVideos,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, stats, recentVideos, error];
}
