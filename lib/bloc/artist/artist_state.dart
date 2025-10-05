import 'package:equatable/equatable.dart';
import '../../models/artist.dart';
import '../../models/video.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();

  @override
  List<Object?> get props => [];
}

class ArtistInitial extends ArtistState {
  const ArtistInitial();
}

class ArtistLoading extends ArtistState {
  const ArtistLoading();
}

class ArtistsLoaded extends ArtistState {
  final List<Artist> artists;

  const ArtistsLoaded({
    required this.artists,
  });

  @override
  List<Object?> get props => [artists];
}

class ArtistDetailLoaded extends ArtistState {
  final Artist artist;
  final List<Video> videos;

  const ArtistDetailLoaded({
    required this.artist,
    required this.videos,
  });

  @override
  List<Object?> get props => [artist, videos];
}

class ArtistError extends ArtistState {
  final String message;

  const ArtistError(this.message);

  @override
  List<Object?> get props => [message];
}

class ArtistActionSuccess extends ArtistState {
  final String message;

  const ArtistActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
