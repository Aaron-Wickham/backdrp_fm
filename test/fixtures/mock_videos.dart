import 'package:backdrp_fm/models/video.dart';

/// Mock video data for testing
class MockVideos {
  static final video1 = Video(
    id: 'video_1',
    title: 'Test Video 1',
    artist: 'Test Artist',
    artistId: 'artist_1',
    youtubeUrl: 'https://www.youtube.com/watch?v=test1',
    youtubeId: 'test1',
    thumbnailUrl: 'https://picsum.photos/seed/test1/400/300',
    description: 'Test description for video 1',
    genres: ['Electronic', 'House'],
    location: VideoLocation(
      venue: 'Test Venue',
      city: 'Los Angeles',
      country: 'USA',
    ),
    duration: 3600, // 1 hour in seconds
    recordedDate: DateTime(2024, 1, 1),
    publishedDate: DateTime(2024, 1, 2),
    status: 'published',
    views: 1000,
    likes: 50,
    featured: true,
    tags: ['live', 'dj set', 'festival'],
  );

  static final video2 = Video(
    id: 'video_2',
    title: 'Test Video 2',
    artist: 'Another Artist',
    artistId: 'artist_2',
    youtubeUrl: 'https://www.youtube.com/watch?v=test2',
    youtubeId: 'test2',
    thumbnailUrl: 'https://picsum.photos/seed/test2/400/300',
    description: 'Test description for video 2',
    genres: ['Hip Hop', 'Rap'],
    location: VideoLocation(
      venue: 'Madison Square Garden',
      city: 'New York',
      country: 'USA',
    ),
    duration: 4500, // 1.25 hours in seconds
    recordedDate: DateTime(2024, 2, 1),
    publishedDate: DateTime(2024, 2, 2),
    status: 'published',
    views: 5000,
    likes: 250,
    featured: false,
    tags: ['concert', 'live performance'],
  );

  static final draftVideo = Video(
    id: 'video_draft',
    title: 'Draft Video',
    artist: 'Test Artist',
    artistId: 'artist_1',
    youtubeUrl: 'https://www.youtube.com/watch?v=draft',
    youtubeId: 'draft',
    thumbnailUrl: 'https://picsum.photos/seed/draft/400/300',
    description: 'Draft video for testing',
    genres: ['R&B', 'Soul'],
    location: VideoLocation(
      venue: 'State Farm Arena',
      city: 'Atlanta',
      country: 'USA',
    ),
    duration: 5400, // 1.5 hours in seconds
    recordedDate: DateTime(2024, 3, 1),
    status: 'draft',
    views: 0,
    likes: 0,
    tags: [],
  );

  static List<Video> get publishedVideos => [video1, video2];
  static List<Video> get allVideos => [video1, video2, draftVideo];
}
