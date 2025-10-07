import 'package:dentaire/data/models/VideoWithQuiz.dart';
import 'package:equatable/equatable.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideosInitialState extends VideoState {}

class VideosLoadingState extends VideoState {}

class VideosLoadedState extends VideoState {
  final List<VideoWithQuiz> videos;
  const VideosLoadedState(this.videos);

  @override
  List<Object> get props => [videos];
}

class VideosErrorState extends VideoState {
  final String message;
  const VideosErrorState(this.message);

  @override
  List<Object> get props => [message];
}
