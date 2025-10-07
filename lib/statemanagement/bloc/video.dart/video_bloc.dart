import 'dart:async';
import 'package:dentaire/statemanagement/bloc/video.dart/video_event.dart';
import 'package:dentaire/statemanagement/bloc/video.dart/video_service.dart';
import 'package:dentaire/statemanagement/bloc/video.dart/video_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoService _videoService;
  StreamSubscription? _videosSubscription;

  VideoBloc(this._videoService) : super(VideosInitialState()) {
    on<LoadVideosEvent>(_onLoadVideos);
    on<AddVideoEvent>(_onAddVideo);
    on<UpdateVideoEvent>(_onUpdateVideo);
    on<DeleteVideoEvent>(_onDeleteVideo);
    on<VideosLoadedEvent>(_onVideosLoaded);
  }

  /// Charger toutes les vidéos avec leurs quiz
  Future<void> _onLoadVideos(
      LoadVideosEvent event, Emitter<VideoState> emit) async {
    emit(VideosLoadingState());
    try {
      _videosSubscription?.cancel();
      _videosSubscription = _videoService.getVideos().listen(
        (videos) {
          add(VideosLoadedEvent(videos));
        },
        onError: (error) {
          emit(VideosErrorState(error.toString()));
        },
      );
    } catch (e) {
      emit(VideosErrorState(e.toString()));
    }
  }

  /// Quand les vidéos sont chargées
  void _onVideosLoaded(VideosLoadedEvent event, Emitter<VideoState> emit) {
    emit(VideosLoadedState(event.videos));
  }

  /// Ajouter une vidéo
  Future<void> _onAddVideo(
      AddVideoEvent event, Emitter<VideoState> emit) async {
    try {
      await _videoService.addVideo(event.video);
    } catch (e) {
      emit(VideosErrorState(e.toString()));
    }
  }

  /// Mettre à jour une vidéo
  Future<void> _onUpdateVideo(
      UpdateVideoEvent event, Emitter<VideoState> emit) async {
    try {
      await _videoService.updateVideo(event.video);
    } catch (e) {
      emit(VideosErrorState(e.toString()));
    }
  }

  /// Supprimer une vidéo
  Future<void> _onDeleteVideo(
      DeleteVideoEvent event, Emitter<VideoState> emit) async {
    try {
      await _videoService.deleteVideo(event.videoId);
    } catch (e) {
      emit(VideosErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _videosSubscription?.cancel();
    return super.close();
  }
}
