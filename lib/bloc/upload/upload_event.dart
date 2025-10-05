import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadVideoRequested extends UploadEvent {
  final Map<String, dynamic> videoData;

  const UploadVideoRequested(this.videoData);

  @override
  List<Object?> get props => [videoData];
}

class ExtractYouTubeId extends UploadEvent {
  final String url;

  const ExtractYouTubeId(this.url);

  @override
  List<Object?> get props => [url];
}

class ValidateForm extends UploadEvent {
  final String youtubeUrl;
  final String title;
  final String artist;
  final String artistId;

  const ValidateForm({
    required this.youtubeUrl,
    required this.title,
    required this.artist,
    required this.artistId,
  });

  @override
  List<Object?> get props => [youtubeUrl, title, artist, artistId];
}

class SaveAsDraft extends UploadEvent {
  final Map<String, dynamic> videoData;

  const SaveAsDraft(this.videoData);

  @override
  List<Object?> get props => [videoData];
}

class PublishVideo extends UploadEvent {
  final Map<String, dynamic> videoData;

  const PublishVideo(this.videoData);

  @override
  List<Object?> get props => [videoData];
}

class ResetUpload extends UploadEvent {
  const ResetUpload();
}
