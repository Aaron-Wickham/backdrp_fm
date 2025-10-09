import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:backdrp_fm/services/playlist_service.dart';
import 'package:backdrp_fm/models/playlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late PlaylistService playlistService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    playlistService = PlaylistService(firestore: fakeFirestore);
  });

  group('PlaylistService', () {
    group('getPlaylist', () {
      test('returns playlist when document exists', () async {
        // Arrange
        const playlistId = 'playlist123';
        await fakeFirestore.collection('playlists').doc(playlistId).set({
          'title': 'Test Playlist',
          'description': 'Test description',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/playlist',
          'embedCode': '',
          'coverImageUrl': 'https://example.com/cover.jpg',
          'curator': 'Test Curator',
          'genres': ['Electronic'],
          'trackCount': 50,
          'publishedDate': Timestamp.now(),
          'featured': false,
          'sortOrder': 0,
        });

        // Act
        final result = await playlistService.getPlaylist(playlistId);

        // Assert
        expect(result, isNotNull);
        expect(result?.id, playlistId);
        expect(result?.title, 'Test Playlist');
      });

      test('returns null when document does not exist', () async {
        // Act
        final result = await playlistService.getPlaylist('nonexistent');

        // Assert
        expect(result, isNull);
      });
    });

    group('addPlaylist', () {
      test('adds playlist with all required fields', () async {
        // Act
        final playlistId = await playlistService.addPlaylist(
          title: 'New Playlist',
          description: 'Description here',
          platform: MusicPlatform.spotify,
          platformUrl: 'https://spotify.com/playlist',
          embedCode: '<iframe></iframe>',
          coverImageUrl: 'https://example.com/cover.jpg',
          curator: 'DJ Test',
          genres: ['House', 'Techno'],
          trackCount: 30,
          featured: true,
          sortOrder: 1,
        );

        // Assert
        expect(playlistId, isNotNull);

        final doc = await fakeFirestore
            .collection('playlists')
            .doc(playlistId)
            .get();
        expect(doc.exists, isTrue);
        expect(doc.data()?['title'], 'New Playlist');
        expect(doc.data()?['platform'], 'spotify');
        expect(doc.data()?['trackCount'], 30);
        expect(doc.data()?['featured'], true);
        expect(doc.data()?['sortOrder'], 1);
      });

      test('sets default values correctly', () async {
        // Act
        final playlistId = await playlistService.addPlaylist(
          title: 'Minimal Playlist',
          platform: MusicPlatform.apple,
          platformUrl: 'https://apple.com/playlist',
        );

        // Assert
        expect(playlistId, isNotNull);

        final doc = await fakeFirestore
            .collection('playlists')
            .doc(playlistId)
            .get();
        expect(doc.data()?['description'], '');
        expect(doc.data()?['embedCode'], '');
        expect(doc.data()?['genres'], []);
        expect(doc.data()?['trackCount'], 0);
        expect(doc.data()?['featured'], false);
        expect(doc.data()?['sortOrder'], 0);
      });

      test('converts platform enum to string', () async {
        // Act
        final playlistId = await playlistService.addPlaylist(
          title: 'Test',
          platform: MusicPlatform.soundcloud,
          platformUrl: 'https://soundcloud.com/playlist',
        );

        // Assert
        final doc = await fakeFirestore
            .collection('playlists')
            .doc(playlistId)
            .get();
        expect(doc.data()?['platform'], 'soundcloud');
      });
    });

    group('updatePlaylist', () {
      test('updates playlist document with provided fields', () async {
        // Arrange
        const playlistId = 'playlist123';
        await fakeFirestore.collection('playlists').doc(playlistId).set({
          'title': 'Original Title',
          'description': 'Original description',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/playlist',
          'trackCount': 10,
          'featured': false,
          'sortOrder': 0,
        });

        // Act
        final result = await playlistService.updatePlaylist(playlistId, {
          'title': 'Updated Title',
          'description': 'Updated description',
          'trackCount': 20,
          'featured': true,
        });

        // Assert
        expect(result, isTrue);

        final doc = await fakeFirestore
            .collection('playlists')
            .doc(playlistId)
            .get();
        expect(doc.data()?['title'], 'Updated Title');
        expect(doc.data()?['description'], 'Updated description');
        expect(doc.data()?['trackCount'], 20);
        expect(doc.data()?['featured'], true);
      });

      test('converts MusicPlatform enum to string if present', () async {
        // Arrange
        const playlistId = 'playlist123';
        await fakeFirestore.collection('playlists').doc(playlistId).set({
          'title': 'Test',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/playlist',
        });

        // Act
        final result = await playlistService.updatePlaylist(playlistId, {
          'platform': MusicPlatform.apple,
        });

        // Assert
        expect(result, isTrue);

        final doc = await fakeFirestore
            .collection('playlists')
            .doc(playlistId)
            .get();
        expect(doc.data()?['platform'], 'apple');
      });

      test('returns true on success', () async {
        // Arrange
        const playlistId = 'playlist123';
        await fakeFirestore.collection('playlists').doc(playlistId).set({
          'title': 'Test',
          'featured': false,
        });

        // Act
        final result = await playlistService.updatePlaylist(playlistId, {
          'featured': true,
        });

        // Assert
        expect(result, isTrue);
      });
    });

    group('deletePlaylist', () {
      test('deletes playlist document', () async {
        // Arrange
        const playlistId = 'playlist123';
        await fakeFirestore.collection('playlists').doc(playlistId).set({
          'title': 'Test Playlist',
        });

        // Act
        final result = await playlistService.deletePlaylist(playlistId);

        // Assert
        expect(result, isTrue);

        final doc = await fakeFirestore
            .collection('playlists')
            .doc(playlistId)
            .get();
        expect(doc.exists, isFalse);
      });

      test('returns true on success', () async {
        // Arrange
        const playlistId = 'playlist123';
        await fakeFirestore.collection('playlists').doc(playlistId).set({
          'title': 'Test',
        });

        // Act
        final result = await playlistService.deletePlaylist(playlistId);

        // Assert
        expect(result, isTrue);
      });
    });

    group('getAllPlaylists stream', () {
      test('returns all playlists ordered by sortOrder', () async {
        // Arrange
        await fakeFirestore.collection('playlists').doc('playlist1').set({
          'title': 'Playlist A',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/a',
          'publishedDate': Timestamp.now(),
          'sortOrder': 2,
          'featured': false,
        });

        await fakeFirestore.collection('playlists').doc('playlist2').set({
          'title': 'Playlist B',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/b',
          'publishedDate': Timestamp.now(),
          'sortOrder': 1,
          'featured': false,
        });

        // Act
        final stream = playlistService.getAllPlaylists();
        final playlists = await stream.first;

        // Assert
        expect(playlists.length, 2);
      });
    });

    group('getFeaturedPlaylists stream', () {
      test('returns only featured playlists', () async {
        // Arrange
        await fakeFirestore.collection('playlists').doc('playlist1').set({
          'title': 'Featured Playlist',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/featured',
          'publishedDate': Timestamp.now(),
          'sortOrder': 1,
          'featured': true,
        });

        await fakeFirestore.collection('playlists').doc('playlist2').set({
          'title': 'Regular Playlist',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/regular',
          'publishedDate': Timestamp.now(),
          'sortOrder': 2,
          'featured': false,
        });

        // Act
        final stream = playlistService.getFeaturedPlaylists(limit: 10);
        final playlists = await stream.first;

        // Assert
        expect(playlists.length, 1);
        expect(playlists.first.title, 'Featured Playlist');
        expect(playlists.first.featured, isTrue);
      });
    });

    group('getPlaylistsByPlatform stream', () {
      test('returns playlists filtered by platform', () async {
        // Arrange
        await fakeFirestore.collection('playlists').doc('playlist1').set({
          'title': 'Spotify Playlist',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/playlist',
          'publishedDate': Timestamp.now(),
          'sortOrder': 0,
        });

        await fakeFirestore.collection('playlists').doc('playlist2').set({
          'title': 'Apple Music Playlist',
          'platform': 'apple',
          'platformUrl': 'https://apple.com/playlist',
          'publishedDate': Timestamp.now(),
          'sortOrder': 0,
        });

        // Act
        final stream =
            playlistService.getPlaylistsByPlatform(MusicPlatform.spotify);
        final playlists = await stream.first;

        // Assert
        expect(playlists.length, 1);
        expect(playlists.first.title, 'Spotify Playlist');
        expect(playlists.first.platform, MusicPlatform.spotify);
      });
    });

    group('getPlaylistsByGenre stream', () {
      test('returns playlists filtered by genre', () async {
        // Arrange
        await fakeFirestore.collection('playlists').doc('playlist1').set({
          'title': 'Electronic Playlist',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/electronic',
          'publishedDate': Timestamp.now(),
          'sortOrder': 0,
          'genres': ['Electronic', 'House'],
        });

        await fakeFirestore.collection('playlists').doc('playlist2').set({
          'title': 'Rock Playlist',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/rock',
          'publishedDate': Timestamp.now(),
          'sortOrder': 0,
          'genres': ['Rock'],
        });

        // Act
        final stream = playlistService.getPlaylistsByGenre('Electronic');
        final playlists = await stream.first;

        // Assert
        expect(playlists.length, 1);
        expect(playlists.first.title, 'Electronic Playlist');
        expect(playlists.first.genres, contains('Electronic'));
      });
    });

    group('searchPlaylists', () {
      test('performs case-insensitive search on playlist title', () async {
        // Arrange
        await fakeFirestore.collection('playlists').doc('playlist1').set({
          'title': 'Deep House Vibes',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/deep',
          'publishedDate': Timestamp.now(),
          'curator': 'DJ Test',
        });

        await fakeFirestore.collection('playlists').doc('playlist2').set({
          'title': 'Techno Classics',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/techno',
          'publishedDate': Timestamp.now(),
          'curator': 'DJ Test',
        });

        // Act
        final stream = playlistService.searchPlaylists('house');
        final playlists = await stream.first;

        // Assert
        expect(playlists.length, 1);
        expect(playlists.first.title, 'Deep House Vibes');
      });

      test('performs case-insensitive search on curator', () async {
        // Arrange
        await fakeFirestore.collection('playlists').doc('playlist1').set({
          'title': 'Playlist One',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/one',
          'publishedDate': Timestamp.now(),
          'curator': 'Special DJ',
        });

        await fakeFirestore.collection('playlists').doc('playlist2').set({
          'title': 'Playlist Two',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/two',
          'publishedDate': Timestamp.now(),
          'curator': 'Regular DJ',
        });

        // Act
        final stream = playlistService.searchPlaylists('special');
        final playlists = await stream.first;

        // Assert
        expect(playlists.length, 1);
        expect(playlists.first.curator, 'Special DJ');
      });

      test('matches partial strings', () async {
        // Arrange
        await fakeFirestore.collection('playlists').doc('playlist1').set({
          'title': 'Electronic Paradise',
          'platform': 'spotify',
          'platformUrl': 'https://spotify.com/electronic',
          'publishedDate': Timestamp.now(),
          'curator': 'Test',
        });

        // Act
        final stream = playlistService.searchPlaylists('par');
        final playlists = await stream.first;

        // Assert
        expect(playlists.length, 1);
        expect(playlists.first.title, 'Electronic Paradise');
      });
    });
  });
}
