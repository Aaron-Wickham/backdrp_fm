import 'package:equatable/equatable.dart';
import '../../models/video.dart';

abstract class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object?> get props => [];
}

class VideoInitial extends VideoState {
  const VideoInitial();
}

class VideoLoading extends VideoState {
  const VideoLoading();
}

class VideoLoaded extends VideoState {
  final List<Video> videos;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const VideoLoaded({
    required this.videos,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  VideoLoaded copyWith({
    List<Video>? videos,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return VideoLoaded(
      videos: videos ?? this.videos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [videos, hasReachedMax, isLoadingMore];
}

class VideoError extends VideoState {
  final String message;

  const VideoError(this.message);

  @override
  List<Object?> get props => [message];
}

class VideoActionSuccess extends VideoState {
  final String message;
  final List<Video> videos;

  const VideoActionSuccess({
    required this.message,
    required this.videos,
  });

  @override
  List<Object?> get props => [message, videos];
}
