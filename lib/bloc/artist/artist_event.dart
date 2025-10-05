import 'package:equatable/equatable.dart';

abstract class ArtistEvent extends Equatable {
  const ArtistEvent();

  @override
  List<Object?> get props => [];
}

class LoadArtists extends ArtistEvent {
  const LoadArtists();
}

class LoadArtistById extends ArtistEvent {
  final String artistId;

  const LoadArtistById(this.artistId);

  @override
  List<Object?> get props => [artistId];
}

class FilterByGenre extends ArtistEvent {
  final String genre;

  const FilterByGenre(this.genre);

  @override
  List<Object?> get props => [genre];
}

class SearchArtists extends ArtistEvent {
  final String query;

  const SearchArtists(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshArtists extends ArtistEvent {
  const RefreshArtists();
}
