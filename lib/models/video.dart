import 'package:cloud_firestore/cloud_firestore.dart';

class VideoLocation {
  final String venue;
  final String city;
  final String country;
  final double? latitude;
  final double? longitude;
  // TODO: Add timezone field for accurate event scheduling
  // TODO: Add venue capacity and type (club, festival, theater, etc.)

  VideoLocation({
    required this.venue,
    required this.city,
    required this.country,
    this.latitude,
    this.longitude,
  });

  factory VideoLocation.fromFirestore(Map<String, dynamic> data) {
    return VideoLocation(
      venue: data['venue'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'venue': venue,
      'city': city,
      'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}

class Video {
  final String id;
  final String youtubeUrl;
  final String youtubeId;
  final String thumbnailUrl;
  final String title;
  final String artist;
  final String artistId;
  final String description;
  final List<String> genres;
  final VideoLocation location;
  final int duration;
  final DateTime? recordedDate;
  final DateTime? publishedDate;
  final String status;
  final int likes;
  final int views;
  final bool featured;
  final int sortOrder;
  final List<String> tags;
  final String? soundcloudUrl;
  final String? spotifyPlaylistId;
  final String? appleMusicPlaylistId;
  // TODO: Add setlist/tracklist field (list of songs performed)
  // TODO: Add comments/reactions feature
  // TODO: Add share count tracking

  Video({
    required this.id,
    required this.youtubeUrl,
    required this.youtubeId,
    required this.thumbnailUrl,
    required this.title,
    required this.artist,
    required this.artistId,
    required this.description,
    required this.genres,
    required this.location,
    required this.duration,
    this.recordedDate,
    this.publishedDate,
    this.status = 'draft',
    this.likes = 0,
    this.views = 0,
    this.featured = false,
    this.sortOrder = 0,
    this.tags = const [],
    this.soundcloudUrl,
    this.spotifyPlaylistId,
    this.appleMusicPlaylistId,
  });

  factory Video.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Video(
      id: doc.id,
      youtubeUrl: data['youtubeUrl'] ?? '',
      youtubeId: data['youtubeId'] ?? '',
      thumbnailUrl: data['thumbnailUrl'] ?? '',
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      artistId: data['artistId'] ?? '',
      description: data['description'] ?? '',
      genres: List<String>.from(data['genres'] ?? []),
      location: VideoLocation.fromFirestore(data['location'] ?? {}),
      duration: data['duration'] ?? 0,
      recordedDate: data['recordedDate'] != null
          ? (data['recordedDate'] as Timestamp).toDate()
          : null,
      publishedDate: data['publishedDate'] != null
          ? (data['publishedDate'] as Timestamp).toDate()
          : null,
      status: data['status'] ?? 'draft',
      likes: data['likes'] ?? 0,
      views: data['views'] ?? 0,
      featured: data['featured'] ?? false,
      sortOrder: data['sortOrder'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      soundcloudUrl: data['soundcloudUrl'],
      spotifyPlaylistId: data['spotifyPlaylistId'],
      appleMusicPlaylistId: data['appleMusicPlaylistId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'youtubeUrl': youtubeUrl,
      'youtubeId': youtubeId,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'artist': artist,
      'artistId': artistId,
      'description': description,
      'genres': genres,
      'location': location.toFirestore(),
      'duration': duration,
      if (recordedDate != null)
        'recordedDate': Timestamp.fromDate(recordedDate!),
      if (publishedDate != null)
        'publishedDate': Timestamp.fromDate(publishedDate!),
      'status': status,
      'likes': likes,
      'views': views,
      'featured': featured,
      'sortOrder': sortOrder,
      'tags': tags,
      if (soundcloudUrl != null) 'soundcloudUrl': soundcloudUrl,
      if (spotifyPlaylistId != null) 'spotifyPlaylistId': spotifyPlaylistId,
      if (appleMusicPlaylistId != null)
        'appleMusicPlaylistId': appleMusicPlaylistId,
    };
  }

  static String? extractYouTubeId(String url) {
    final regexPatterns = [
      RegExp(
          r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com\/watch\?.*v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'^([a-zA-Z0-9_-]{11})$'),
    ];

    for (final regex in regexPatterns) {
      final match = regex.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    return null;
  }

  static String getYouTubeThumbnail(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }
}
