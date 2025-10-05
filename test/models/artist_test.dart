import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:backdrp_fm/models/artist.dart';

void main() {
  group('Artist', () {
    test('creates instance with required fields', () {
      final artist = Artist(
        id: 'artist1',
        name: 'Test Artist',
      );

      expect(artist.id, 'artist1');
      expect(artist.name, 'Test Artist');
      expect(artist.bio, '');
      expect(artist.profileImageUrl, '');
      expect(artist.bannerImageUrl, '');
      expect(artist.socialLinks, isEmpty);
      expect(artist.genres, isEmpty);
      expect(artist.location, '');
      expect(artist.totalSets, 0);
      expect(artist.createdDate, isNull);
      expect(artist.active, true);
    });

    test('creates instance with all fields', () {
      final createdDate = DateTime(2024, 1, 1);
      final artist = Artist(
        id: 'artist1',
        name: 'Test Artist',
        bio: 'An amazing artist',
        profileImageUrl: 'https://example.com/profile.jpg',
        bannerImageUrl: 'https://example.com/banner.jpg',
        socialLinks: {
          'instagram': 'https://instagram.com/testartist',
          'soundcloud': 'https://soundcloud.com/testartist',
        },
        genres: ['Electronic', 'House'],
        location: 'London, UK',
        totalSets: 10,
        createdDate: createdDate,
        active: true,
      );

      expect(artist.bio, 'An amazing artist');
      expect(artist.profileImageUrl, 'https://example.com/profile.jpg');
      expect(artist.socialLinks['instagram'], 'https://instagram.com/testartist');
      expect(artist.genres, ['Electronic', 'House']);
      expect(artist.location, 'London, UK');
      expect(artist.totalSets, 10);
      expect(artist.createdDate, createdDate);
    });

    test('fromFirestore creates instance from document', () async {
      final firestore = FakeFirebaseFirestore();
      final createdDate = DateTime(2024, 1, 1);

      await firestore.collection('artists').doc('artist1').set({
        'name': 'Test Artist',
        'bio': 'An amazing artist',
        'profileImageUrl': 'https://example.com/profile.jpg',
        'bannerImageUrl': 'https://example.com/banner.jpg',
        'socialLinks': {
          'instagram': 'https://instagram.com/testartist',
        },
        'genres': ['Electronic', 'House'],
        'location': 'London, UK',
        'totalSets': 10,
        'createdDate': Timestamp.fromDate(createdDate),
        'active': true,
      });

      final doc = await firestore.collection('artists').doc('artist1').get();
      final artist = Artist.fromFirestore(doc);

      expect(artist.id, 'artist1');
      expect(artist.name, 'Test Artist');
      expect(artist.bio, 'An amazing artist');
      expect(artist.totalSets, 10);
      expect(artist.active, true);
    });

    test('fromFirestore handles missing optional fields', () async {
      final firestore = FakeFirebaseFirestore();

      await firestore.collection('artists').doc('artist1').set({
        'name': 'Test Artist',
      });

      final doc = await firestore.collection('artists').doc('artist1').get();
      final artist = Artist.fromFirestore(doc);

      expect(artist.bio, '');
      expect(artist.profileImageUrl, '');
      expect(artist.socialLinks, isEmpty);
      expect(artist.genres, isEmpty);
      expect(artist.createdDate, isNull);
    });

    test('toFirestore converts to map', () {
      final createdDate = DateTime(2024, 1, 1);
      final artist = Artist(
        id: 'artist1',
        name: 'Test Artist',
        bio: 'An amazing artist',
        profileImageUrl: 'https://example.com/profile.jpg',
        bannerImageUrl: 'https://example.com/banner.jpg',
        socialLinks: {
          'instagram': 'https://instagram.com/testartist',
        },
        genres: ['Electronic', 'House'],
        location: 'London, UK',
        totalSets: 10,
        createdDate: createdDate,
        active: true,
      );

      final map = artist.toFirestore();

      expect(map['name'], 'Test Artist');
      expect(map['bio'], 'An amazing artist');
      expect(map['totalSets'], 10);
      expect(map['active'], true);
      expect(map['createdDate'], isA<Timestamp>());
    });

    test('toFirestore excludes null createdDate', () {
      final artist = Artist(
        id: 'artist1',
        name: 'Test Artist',
      );

      final map = artist.toFirestore();

      expect(map.containsKey('createdDate'), isFalse);
    });
  });
}
