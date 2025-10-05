import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:backdrp_fm/models/video.dart';

void main() {
  group('VideoLocation', () {
    test('creates instance with required fields', () {
      final location = VideoLocation(
        venue: 'The Venue',
        city: 'London',
        country: 'UK',
      );

      expect(location.venue, 'The Venue');
      expect(location.city, 'London');
      expect(location.country, 'UK');
      expect(location.latitude, isNull);
      expect(location.longitude, isNull);
    });

    test('creates instance with optional coordinates', () {
      final location = VideoLocation(
        venue: 'The Venue',
        city: 'London',
        country: 'UK',
        latitude: 51.5074,
        longitude: -0.1278,
      );

      expect(location.latitude, 51.5074);
      expect(location.longitude, -0.1278);
    });

    test('fromFirestore creates instance from map', () {
      final data = {
        'venue': 'The Venue',
        'city': 'London',
        'country': 'UK',
        'latitude': 51.5074,
        'longitude': -0.1278,
      };

      final location = VideoLocation.fromFirestore(data);

      expect(location.venue, 'The Venue');
      expect(location.city, 'London');
      expect(location.country, 'UK');
      expect(location.latitude, 51.5074);
      expect(location.longitude, -0.1278);
    });

    test('fromFirestore handles missing optional fields', () {
      final data = {
        'venue': 'The Venue',
        'city': 'London',
        'country': 'UK',
      };

      final location = VideoLocation.fromFirestore(data);

      expect(location.latitude, isNull);
      expect(location.longitude, isNull);
    });

    test('toFirestore converts to map', () {
      final location = VideoLocation(
        venue: 'The Venue',
        city: 'London',
        country: 'UK',
        latitude: 51.5074,
        longitude: -0.1278,
      );

      final map = location.toFirestore();

      expect(map['venue'], 'The Venue');
      expect(map['city'], 'London');
      expect(map['country'], 'UK');
      expect(map['latitude'], 51.5074);
      expect(map['longitude'], -0.1278);
    });

    test('toFirestore excludes null coordinates', () {
      final location = VideoLocation(
        venue: 'The Venue',
        city: 'London',
        country: 'UK',
      );

      final map = location.toFirestore();

      expect(map.containsKey('latitude'), isFalse);
      expect(map.containsKey('longitude'), isFalse);
    });
  });

  group('Video', () {
    late VideoLocation testLocation;

    setUp(() {
      testLocation = VideoLocation(
        venue: 'The Venue',
        city: 'London',
        country: 'UK',
      );
    });

    test('creates instance with required fields', () {
      final video = Video(
        id: 'video1',
        youtubeUrl: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
        youtubeId: 'dQw4w9WgXcQ',
        thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
        title: 'Test Video',
        artist: 'Test Artist',
        artistId: 'artist1',
        description: 'A test video',
        genres: ['Electronic', 'House'],
        location: testLocation,
        duration: 3600,
      );

      expect(video.id, 'video1');
      expect(video.title, 'Test Video');
      expect(video.status, 'draft');
      expect(video.likes, 0);
      expect(video.views, 0);
      expect(video.featured, false);
    });

    test('fromFirestore creates instance from document', () async {
      final firestore = FakeFirebaseFirestore();
      final recordedDate = DateTime(2024, 1, 1);
      final publishedDate = DateTime(2024, 1, 15);

      await firestore.collection('videos').doc('video1').set({
        'youtubeUrl': 'https://youtube.com/watch?v=dQw4w9WgXcQ',
        'youtubeId': 'dQw4w9WgXcQ',
        'thumbnailUrl': 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
        'title': 'Test Video',
        'artist': 'Test Artist',
        'artistId': 'artist1',
        'description': 'A test video',
        'genres': ['Electronic', 'House'],
        'location': {
          'venue': 'The Venue',
          'city': 'London',
          'country': 'UK',
        },
        'duration': 3600,
        'recordedDate': Timestamp.fromDate(recordedDate),
        'publishedDate': Timestamp.fromDate(publishedDate),
        'status': 'published',
        'likes': 100,
        'views': 1000,
        'featured': true,
        'sortOrder': 5,
        'tags': ['techno', 'live'],
        'soundcloudUrl': 'https://soundcloud.com/test',
      });

      final doc = await firestore.collection('videos').doc('video1').get();
      final video = Video.fromFirestore(doc);

      expect(video.id, 'video1');
      expect(video.title, 'Test Video');
      expect(video.artist, 'Test Artist');
      expect(video.status, 'published');
      expect(video.likes, 100);
      expect(video.views, 1000);
      expect(video.featured, true);
      expect(video.tags, ['techno', 'live']);
      expect(video.soundcloudUrl, 'https://soundcloud.com/test');
    });

    test('toFirestore converts to map', () {
      final recordedDate = DateTime(2024, 1, 1);
      final video = Video(
        id: 'video1',
        youtubeUrl: 'https://youtube.com/watch?v=dQw4w9WgXcQ',
        youtubeId: 'dQw4w9WgXcQ',
        thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
        title: 'Test Video',
        artist: 'Test Artist',
        artistId: 'artist1',
        description: 'A test video',
        genres: ['Electronic', 'House'],
        location: testLocation,
        duration: 3600,
        recordedDate: recordedDate,
        status: 'published',
      );

      final map = video.toFirestore();

      expect(map['title'], 'Test Video');
      expect(map['status'], 'published');
      expect(map['recordedDate'], isA<Timestamp>());
    });

    test('extractYouTubeId extracts from standard URL', () {
      final id = Video.extractYouTubeId('https://youtube.com/watch?v=dQw4w9WgXcQ');
      expect(id, 'dQw4w9WgXcQ');
    });

    test('extractYouTubeId extracts from short URL', () {
      final id = Video.extractYouTubeId('https://youtu.be/dQw4w9WgXcQ');
      expect(id, 'dQw4w9WgXcQ');
    });

    test('extractYouTubeId extracts from embed URL', () {
      final id = Video.extractYouTubeId('https://youtube.com/embed/dQw4w9WgXcQ');
      expect(id, 'dQw4w9WgXcQ');
    });

    test('extractYouTubeId returns null for invalid URL', () {
      final id = Video.extractYouTubeId('https://invalid.com/video');
      expect(id, isNull);
    });

    test('getYouTubeThumbnail returns correct URL', () {
      final thumbnail = Video.getYouTubeThumbnail('dQw4w9WgXcQ');
      expect(thumbnail, 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg');
    });
  });
}
