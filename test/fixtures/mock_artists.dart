import 'package:backdrp_fm/models/artist.dart';

/// Mock artist data for testing
class MockArtists {
  static final artist1 = Artist(
    id: 'artist_1',
    name: 'Test Artist',
    bio: 'A test artist for unit testing',
    profileImageUrl: 'https://ui-avatars.com/api/?name=Test+Artist&size=400',
    bannerImageUrl: 'https://picsum.photos/seed/artist1/1200/400',
    genres: ['Electronic', 'House', 'Techno'],
    location: 'Los Angeles, CA',
    socialLinks: {
      'website': 'https://testartist.com',
      'instagram': 'https://instagram.com/testartist',
      'twitter': 'https://twitter.com/testartist',
      'spotify': 'https://open.spotify.com/artist/test',
    },
    totalSets: 10,
    createdDate: DateTime(2023, 1, 1),
    active: true,
  );

  static final artist2 = Artist(
    id: 'artist_2',
    name: 'Another Artist',
    bio: 'Another test artist for testing',
    profileImageUrl: 'https://ui-avatars.com/api/?name=Another+Artist&size=400',
    bannerImageUrl: 'https://picsum.photos/seed/artist2/1200/400',
    genres: ['Hip Hop', 'Rap'],
    location: 'New York, NY',
    socialLinks: {
      'website': 'https://anotherartist.com',
      'instagram': 'https://instagram.com/anotherartist',
      'spotify': 'https://open.spotify.com/artist/another',
    },
    totalSets: 5,
    createdDate: DateTime(2023, 6, 1),
    active: true,
  );

  static final artist3 = Artist(
    id: 'artist_3',
    name: 'Third Artist',
    bio: 'Third test artist',
    profileImageUrl: 'https://ui-avatars.com/api/?name=Third+Artist&size=400',
    bannerImageUrl: 'https://picsum.photos/seed/artist3/1200/400',
    genres: ['R&B', 'Soul'],
    location: 'Atlanta, GA',
    socialLinks: {
      'website': 'https://thirdartist.com',
      'soundcloud': 'https://soundcloud.com/thirdartist',
    },
    totalSets: 3,
    createdDate: DateTime(2023, 12, 1),
    active: true,
  );

  static List<Artist> get allArtists => [artist1, artist2, artist3];
}
