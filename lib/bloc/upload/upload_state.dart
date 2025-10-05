import 'package:equatable/equatable.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {
  const UploadInitial();
}

class ExtractingVideoInfo extends UploadState {
  const ExtractingVideoInfo();
}

class VideoInfoExtracted extends UploadState {
  final String youtubeId;
  final String thumbnailUrl;
  final int? duration;

  const VideoInfoExtracted({
    required this.youtubeId,
    required this.thumbnailUrl,
    this.duration,
  });

  @override
  List<Object?> get props => [youtubeId, thumbnailUrl, duration];
}

class FormValidating extends UploadState {
  const FormValidating();
}

class FormValid extends UploadState {
  final String youtubeId;
  final String thumbnailUrl;

  const FormValid({
    required this.youtubeId,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [youtubeId, thumbnailUrl];
}

class FormInvalid extends UploadState {
  final String message;

  const FormInvalid(this.message);

  @override
  List<Object?> get props => [message];
}

class Uploading extends UploadState {
  final double progress;
  final String status;

  const Uploading({
    this.progress = 0.0,
    this.status = 'Uploading...',
  });

  @override
  List<Object?> get props => [progress, status];
}

class UploadSuccess extends UploadState {
  final String videoId;
  final String message;

  const UploadSuccess({
    required this.videoId,
    this.message = 'Video uploaded successfully',
  });

  @override
  List<Object?> get props => [videoId, message];
}

class UploadError extends UploadState {
  final String message;

  const UploadError(this.message);

  @override
  List<Object?> get props => [message];
}
