import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateProfile extends ProfileEvent {
  final String userId;
  final String? displayName;
  final String? profileImageUrl;

  const UpdateProfile({
    required this.userId,
    this.displayName,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [userId, displayName, profileImageUrl];
}

class LoadLikedVideos extends ProfileEvent {
  final String userId;

  const LoadLikedVideos(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadSavedVideos extends ProfileEvent {
  final String userId;

  const LoadSavedVideos(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateNotificationSettings extends ProfileEvent {
  final String userId;
  final bool? newSets;
  final bool? artistUpdates;
  final bool? weeklyDigest;
  final bool? emailSubscribed;
  final bool? pushSubscribed;

  const UpdateNotificationSettings({
    required this.userId,
    this.newSets,
    this.artistUpdates,
    this.weeklyDigest,
    this.emailSubscribed,
    this.pushSubscribed,
  });

  @override
  List<Object?> get props => [
        userId,
        newSets,
        artistUpdates,
        weeklyDigest,
        emailSubscribed,
        pushSubscribed
      ];
}

class ToggleEmailSubscription extends ProfileEvent {
  final String userId;
  final bool subscribe;

  const ToggleEmailSubscription({
    required this.userId,
    required this.subscribe,
  });

  @override
  List<Object?> get props => [userId, subscribe];
}

class TogglePushSubscription extends ProfileEvent {
  final String userId;
  final bool subscribe;

  const TogglePushSubscription({
    required this.userId,
    required this.subscribe,
  });

  @override
  List<Object?> get props => [userId, subscribe];
}

class UpdateFavoriteGenres extends ProfileEvent {
  final String userId;
  final List<String> genres;

  const UpdateFavoriteGenres({
    required this.userId,
    required this.genres,
  });

  @override
  List<Object?> get props => [userId, genres];
}

class RefreshProfile extends ProfileEvent {
  const RefreshProfile();
}
