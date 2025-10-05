import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class LoadVideos extends VideoEvent {
  const LoadVideos();
}

class LoadFeaturedVideos extends VideoEvent {
  final int limit;

  const LoadFeaturedVideos({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class LoadVideosByArtist extends VideoEvent {
  final String artistId;

  const LoadVideosByArtist(this.artistId);

  @override
  List<Object?> get props => [artistId];
}

class FilterVideos extends VideoEvent {
  final List<String>? genres;
  final String? artistId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? city;
  final String? country;

  const FilterVideos({
    this.genres,
    this.artistId,
    this.fromDate,
    this.toDate,
    this.city,
    this.country,
  });

  @override
  List<Object?> get props => [
        genres,
        artistId,
        fromDate,
        toDate,
        city,
        country,
      ];
}

class LikeVideo extends VideoEvent {
  final String videoId;
  final String userId;

  const LikeVideo({
    required this.videoId,
    required this.userId,
  });

  @override
  List<Object?> get props => [videoId, userId];
}

class SaveVideo extends VideoEvent {
  final String videoId;
  final String userId;

  const SaveVideo({
    required this.videoId,
    required this.userId,
  });

  @override
  List<Object?> get props => [videoId, userId];
}

class SearchVideos extends VideoEvent {
  final String query;

  const SearchVideos(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreVideos extends VideoEvent {
  const LoadMoreVideos();
}

class RefreshVideos extends VideoEvent {
  const RefreshVideos();
}
