import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:backdrp_fm/models/playlist.dart';

void main() {
  group('MusicPlatform', () {
    test('fromString returns correct platform', () {
      expect(MusicPlatform.fromString('spotify'), MusicPlatform.spotify);
      expect(MusicPlatform.fromString('apple'), MusicPlatform.apple);
      expect(MusicPlatform.fromString('soundcloud'), MusicPlatform.soundcloud);
    });

    test('fromString returns spotify for invalid platform', () {
      expect(MusicPlatform.fromString('invalid'), MusicPlatform.spotify);
    });
  });

  group('Playlist', () {
    test('creates instance with required fields', () {
      final playlist = Playlist(
        id: 'playlist1',
        title: 'Best of Electronic',
        platform: MusicPlatform.spotify,
        platformUrl: 'https://open.spotify.com/playlist/123',
      );

      expect(playlist.id, 'playlist1');
      expect(playlist.title, 'Best of Electronic');
      expect(playlist.platform, MusicPlatform.spotify);
      expect(playlist.platformUrl, 'https://open.spotify.com/playlist/123');
      expect(playlist.description, '');
      expect(playlist.embedCode, '');
      expect(playlist.genres, isEmpty);
      expect(playlist.trackCount, 0);
      expect(playlist.featured, false);
      expect(playlist.sortOrder, 0);
    });

    test('creates instance with all fields', () {
      final publishedDate = DateTime(2024, 1, 1);
      final playlist = Playlist(
        id: 'playlist1',
        title: 'Best of Electronic',
        description: 'The best electronic tracks',
        platform: MusicPlatform.spotify,
        platformUrl: 'https://open.spotify.com/playlist/123',
        embedCode: '<iframe src="..."></iframe>',
        coverImageUrl: 'https://example.com/cover.jpg',
        curator: 'BACKDRP.FM',
        genres: ['Electronic', 'House'],
        trackCount: 50,
        publishedDate: publishedDate,
        featured: true,
        sortOrder: 5,
      );

      expect(playlist.description, 'The best electronic tracks');
      expect(playlist.embedCode, '<iframe src="..."></iframe>');
      expect(playlist.coverImageUrl, 'https://example.com/cover.jpg');
      expect(playlist.curator, 'BACKDRP.FM');
      expect(playlist.genres, ['Electronic', 'House']);
      expect(playlist.trackCount, 50);
      expect(playlist.publishedDate, publishedDate);
      expect(playlist.featured, true);
      expect(playlist.sortOrder, 5);
    });

    test('fromFirestore creates instance from document', () async {
      final firestore = FakeFirebaseFirestore();
      final publishedDate = DateTime(2024, 1, 1);

      await firestore.collection('playlists').doc('playlist1').set({
        'title': 'Best of Electronic',
        'description': 'The best electronic tracks',
        'platform': 'spotify',
        'platformUrl': 'https://open.spotify.com/playlist/123',
        'embedCode': '<iframe src="..."></iframe>',
        'coverImageUrl': 'https://example.com/cover.jpg',
        'curator': 'BACKDRP.FM',
        'genres': ['Electronic', 'House'],
        'trackCount': 50,
        'publishedDate': Timestamp.fromDate(publishedDate),
        'featured': true,
        'sortOrder': 5,
      });

      final doc =
          await firestore.collection('playlists').doc('playlist1').get();
      final playlist = Playlist.fromFirestore(doc);

      expect(playlist.id, 'playlist1');
      expect(playlist.title, 'Best of Electronic');
      expect(playlist.platform, MusicPlatform.spotify);
      expect(playlist.trackCount, 50);
      expect(playlist.featured, true);
    });

    test('fromFirestore handles missing optional fields', () async {
      final firestore = FakeFirebaseFirestore();

      await firestore.collection('playlists').doc('playlist1').set({
        'title': 'Best of Electronic',
        'platform': 'apple',
        'platformUrl': 'https://music.apple.com/playlist/123',
      });

      final doc =
          await firestore.collection('playlists').doc('playlist1').get();
      final playlist = Playlist.fromFirestore(doc);

      expect(playlist.platform, MusicPlatform.apple);
      expect(playlist.description, '');
      expect(playlist.genres, isEmpty);
      expect(playlist.publishedDate, isNull);
    });

    test('toFirestore converts to map', () {
      final publishedDate = DateTime(2024, 1, 1);
      final playlist = Playlist(
        id: 'playlist1',
        title: 'Best of Electronic',
        description: 'The best electronic tracks',
        platform: MusicPlatform.soundcloud,
        platformUrl: 'https://soundcloud.com/playlist/123',
        trackCount: 30,
        publishedDate: publishedDate,
        featured: true,
      );

      final map = playlist.toFirestore();

      expect(map['title'], 'Best of Electronic');
      expect(map['platform'], 'soundcloud');
      expect(map['trackCount'], 30);
      expect(map['featured'], true);
      expect(map['publishedDate'], isA<Timestamp>());
    });

    test('toFirestore excludes null publishedDate', () {
      final playlist = Playlist(
        id: 'playlist1',
        title: 'Best of Electronic',
        platform: MusicPlatform.spotify,
        platformUrl: 'https://open.spotify.com/playlist/123',
      );

      final map = playlist.toFirestore();

      expect(map.containsKey('publishedDate'), isFalse);
    });
  });
}
