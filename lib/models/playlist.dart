import 'package:cloud_firestore/cloud_firestore.dart';

enum MusicPlatform {
  spotify,
  apple,
  soundcloud;

  static MusicPlatform fromString(String platform) {
    return MusicPlatform.values.firstWhere(
      (e) => e.name == platform,
      orElse: () => MusicPlatform.spotify,
    );
  }
}

class Playlist {
  final String id;
  final String title;
  final String description;
  final MusicPlatform platform;
  final String platformUrl;
  final String embedCode;
  final String coverImageUrl;
  final String curator;
  final List<String> genres;
  final int trackCount;
  final DateTime? publishedDate;
  final bool featured;
  final int sortOrder;

  Playlist({
    required this.id,
    required this.title,
    this.description = '',
    required this.platform,
    required this.platformUrl,
    this.embedCode = '',
    this.coverImageUrl = '',
    this.curator = '',
    this.genres = const [],
    this.trackCount = 0,
    this.publishedDate,
    this.featured = false,
    this.sortOrder = 0,
  });

  factory Playlist.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Playlist(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      platform: MusicPlatform.fromString(data['platform'] ?? 'spotify'),
      platformUrl: data['platformUrl'] ?? '',
      embedCode: data['embedCode'] ?? '',
      coverImageUrl: data['coverImageUrl'] ?? '',
      curator: data['curator'] ?? '',
      genres: List<String>.from(data['genres'] ?? []),
      trackCount: data['trackCount'] ?? 0,
      publishedDate: data['publishedDate'] != null
          ? (data['publishedDate'] as Timestamp).toDate()
          : null,
      featured: data['featured'] ?? false,
      sortOrder: data['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'platform': platform.name,
      'platformUrl': platformUrl,
      'embedCode': embedCode,
      'coverImageUrl': coverImageUrl,
      'curator': curator,
      'genres': genres,
      'trackCount': trackCount,
      if (publishedDate != null)
        'publishedDate': Timestamp.fromDate(publishedDate!),
      'featured': featured,
      'sortOrder': sortOrder,
    };
  }
}
