import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToHome extends NavigationEvent {
  const NavigateToHome();
}

class NavigateToArchive extends NavigationEvent {
  const NavigateToArchive();
}

class NavigateToArtists extends NavigationEvent {
  const NavigateToArtists();
}

class NavigateToProfile extends NavigationEvent {
  const NavigateToProfile();
}

class NavigateToVideo extends NavigationEvent {
  final String videoId;

  const NavigateToVideo(this.videoId);

  @override
  List<Object?> get props => [videoId];
}

class NavigateToArtist extends NavigationEvent {
  final String artistId;

  const NavigateToArtist(this.artistId);

  @override
  List<Object?> get props => [artistId];
}

class NavigateToPlaylist extends NavigationEvent {
  final String playlistId;

  const NavigateToPlaylist(this.playlistId);

  @override
  List<Object?> get props => [playlistId];
}

class NavigateToSettings extends NavigationEvent {
  const NavigateToSettings();
}

class NavigateBack extends NavigationEvent {
  const NavigateBack();
}

class HandleDeepLink extends NavigationEvent {
  final String deepLink;

  const HandleDeepLink(this.deepLink);

  @override
  List<Object?> get props => [deepLink];
}

class SetCurrentIndex extends NavigationEvent {
  final int index;

  const SetCurrentIndex(this.index);

  @override
  List<Object?> get props => [index];
}
