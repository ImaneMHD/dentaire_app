import 'package:dentaire/data/models/VideoWithQuiz.dart';
import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class LoadVideosEvent extends VideoEvent {}

class AddVideoEvent extends VideoEvent {
  final VideoWithQuiz video;
  const AddVideoEvent(this.video);

  @override
  List<Object> get props => [video];
}

class UpdateVideoEvent extends VideoEvent {
  final VideoWithQuiz video;
  const UpdateVideoEvent(this.video);

  @override
  List<Object> get props => [video];
}

class DeleteVideoEvent extends VideoEvent {
  final String videoId;
  const DeleteVideoEvent(this.videoId);

  @override
  List<Object> get props => [videoId];
}

class VideosLoadedEvent extends VideoEvent {
  final List<VideoWithQuiz> videos;
  const VideosLoadedEvent(this.videos);

  @override
  List<Object> get props => [videos];
}
