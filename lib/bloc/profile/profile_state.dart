import 'package:equatable/equatable.dart';
import '../../models/app_user.dart';
import '../../models/video.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final AppUser user;
  final List<Video> likedVideos;
  final List<Video> savedVideos;

  const ProfileLoaded({
    required this.user,
    this.likedVideos = const [],
    this.savedVideos = const [],
  });

  ProfileLoaded copyWith({
    AppUser? user,
    List<Video>? likedVideos,
    List<Video>? savedVideos,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      likedVideos: likedVideos ?? this.likedVideos,
      savedVideos: savedVideos ?? this.savedVideos,
    );
  }

  @override
  List<Object?> get props => [user, likedVideos, savedVideos];
}

class ProfileUpdating extends ProfileState {
  final AppUser user;
  final String message;

  const ProfileUpdating({
    required this.user,
    this.message = 'Updating profile...',
  });

  @override
  List<Object?> get props => [user, message];
}

class ProfileUpdateSuccess extends ProfileState {
  final AppUser user;
  final String message;

  const ProfileUpdateSuccess({
    required this.user,
    this.message = 'Profile updated successfully',
  });

  @override
  List<Object?> get props => [user, message];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
