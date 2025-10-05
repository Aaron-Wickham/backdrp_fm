import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:backdrp_fm/services/artist_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late ArtistService artistService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    artistService = ArtistService(firestore: fakeFirestore);
  });

  group('ArtistService', () {
    group('getArtist', () {
      test('returns artist when document exists', () async {
        // Arrange
        const artistId = 'artist123';
        await fakeFirestore.collection('dev_artists').doc(artistId).set({
          'name': 'Test Artist',
          'bio': 'Test bio',
          'profileImageUrl': 'https://example.com/image.jpg',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': ['Electronic'],
          'location': 'LA',
          'totalSets': 5,
          'createdDate': DateTime.now(),
          'active': true,
        });

        // Act
        final result = await artistService.getArtist(artistId);

        // Assert
        expect(result, isNotNull);
        expect(result?.id, artistId);
        expect(result?.name, 'Test Artist');
        expect(result?.bio, 'Test bio');
      });

      test('returns null when document does not exist', () async {
        // Act
        final result = await artistService.getArtist('nonexistent');

        // Assert
        expect(result, isNull);
      });
    });

    group('addArtist', () {
      test('adds artist with all required fields', () async {
        // Act
        final artistId = await artistService.addArtist(
          name: 'New Artist',
          bio: 'Bio text',
          profileImageUrl: 'https://example.com/profile.jpg',
          bannerImageUrl: 'https://example.com/banner.jpg',
          socialLinks: {'instagram': '@artist'},
          genres: ['House', 'Techno'],
          location: 'Berlin',
          active: true,
        );

        // Assert
        expect(artistId, isNotNull);

        final doc = await fakeFirestore
            .collection('dev_artists')
            .doc(artistId)
            .get();
        expect(doc.exists, isTrue);
        expect(doc.data()?['name'], 'New Artist');
        expect(doc.data()?['bio'], 'Bio text');
        expect(doc.data()?['genres'], ['House', 'Techno']);
        expect(doc.data()?['totalSets'], 0);
        expect(doc.data()?['active'], true);
      });

      test('sets default values correctly', () async {
        // Act
        final artistId = await artistService.addArtist(name: 'Minimal Artist');

        // Assert
        expect(artistId, isNotNull);

        final doc = await fakeFirestore
            .collection('dev_artists')
            .doc(artistId)
            .get();
        expect(doc.data()?['bio'], '');
        expect(doc.data()?['profileImageUrl'], '');
        expect(doc.data()?['genres'], []);
        expect(doc.data()?['totalSets'], 0);
        expect(doc.data()?['active'], true);
      });
    });

    group('updateArtist', () {
      test('updates artist document with provided fields', () async {
        // Arrange
        const artistId = 'artist123';
        await fakeFirestore.collection('dev_artists').doc(artistId).set({
          'name': 'Original Name',
          'bio': 'Original bio',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': [],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': true,
        });

        // Act
        final result = await artistService.updateArtist(artistId, {
          'name': 'Updated Name',
          'bio': 'Updated bio',
          'location': 'Paris',
        });

        // Assert
        expect(result, isTrue);

        final doc = await fakeFirestore
            .collection('dev_artists')
            .doc(artistId)
            .get();
        expect(doc.data()?['name'], 'Updated Name');
        expect(doc.data()?['bio'], 'Updated bio');
        expect(doc.data()?['location'], 'Paris');
      });

      test('returns true on success', () async {
        // Arrange
        const artistId = 'artist123';
        await fakeFirestore.collection('dev_artists').doc(artistId).set({
          'name': 'Test Artist',
          'totalSets': 0,
          'active': true,
        });

        // Act
        final result = await artistService.updateArtist(artistId, {
          'totalSets': 10,
        });

        // Assert
        expect(result, isTrue);
      });
    });

    group('getActiveArtists stream', () {
      test('returns stream of active artists', () async {
        // Arrange
        await fakeFirestore.collection('dev_artists').doc('artist1').set({
          'name': 'Artist A',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': [],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': true,
        });

        await fakeFirestore.collection('dev_artists').doc('artist2').set({
          'name': 'Artist B',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': [],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': true,
        });

        await fakeFirestore.collection('dev_artists').doc('artist3').set({
          'name': 'Inactive Artist',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': [],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': false,
        });

        // Act
        final stream = artistService.getActiveArtists();
        final artists = await stream.first;

        // Assert
        expect(artists.length, 2);
        expect(artists.every((a) => a.active), isTrue);
      });
    });

    group('getArtistsByGenre stream', () {
      test('returns artists filtered by genre', () async {
        // Arrange
        await fakeFirestore.collection('dev_artists').doc('artist1').set({
          'name': 'Electronic Artist',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': ['Electronic', 'House'],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': true,
        });

        await fakeFirestore.collection('dev_artists').doc('artist2').set({
          'name': 'Rock Artist',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': ['Rock'],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': true,
        });

        // Act
        final stream = artistService.getArtistsByGenre('Electronic');
        final artists = await stream.first;

        // Assert
        expect(artists.length, 1);
        expect(artists.first.name, 'Electronic Artist');
        expect(artists.first.genres, contains('Electronic'));
      });
    });

    group('searchArtists', () {
      test('performs case-insensitive search on artist name', () async {
        // Arrange
        await fakeFirestore.collection('dev_artists').doc('artist1').set({
          'name': 'DJ Shadow',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': [],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': true,
        });

        await fakeFirestore.collection('dev_artists').doc('artist2').set({
          'name': 'The Chemical Brothers',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': [],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': true,
        });

        // Act
        final stream = artistService.searchArtists('shadow');
        final artists = await stream.first;

        // Assert
        expect(artists.length, 1);
        expect(artists.first.name, 'DJ Shadow');
      });

      test('only returns active artists in search', () async {
        // Arrange
        await fakeFirestore.collection('dev_artists').doc('artist1').set({
          'name': 'Active Test',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': [],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': true,
        });

        await fakeFirestore.collection('dev_artists').doc('artist2').set({
          'name': 'Inactive Test',
          'bio': '',
          'profileImageUrl': '',
          'bannerImageUrl': '',
          'socialLinks': {},
          'genres': [],
          'location': '',
          'totalSets': 0,
          'createdDate': DateTime.now(),
          'active': false,
        });

        // Act
        final stream = artistService.searchArtists('test');
        final artists = await stream.first;

        // Assert
        expect(artists.length, 1);
        expect(artists.first.name, 'Active Test');
      });
    });

  });
}
