// Comprehensive test data seeding script
const admin = require('firebase-admin');

// Parse command line arguments
const args = process.argv.slice(2);
const projectFlag = args.find(arg => arg.startsWith('--project='));
const projectId = projectFlag ? projectFlag.split('=')[1] : 'backdrp-fm-dev';

// Determine service account key based on project
// Note: All environments use the same collection names (no prefixes)
let serviceAccountPath = './functions/service-account-key-dev.json';

if (projectId.includes('staging')) {
  serviceAccountPath = './functions/service-account-key-staging.json';
} else if (projectId.includes('prod') || projectId === 'backdrop-fm') {
  serviceAccountPath = './functions/service-account-key.json';
}

console.log(`🔧 Initializing Firebase Admin SDK for project: ${projectId}`);
console.log(`📝 All environments use the same collection structure (no prefixes)`);
console.log(`🔑 Using service account: ${serviceAccountPath}`);

const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: projectId
});

const db = admin.firestore();

// All environments use the same collection names
const COLLECTIONS = {
  videos: 'videos',
  users: 'users',
  artists: 'artists',
  playlists: 'playlists'
};

// Test Videos
const testVideos = [
  {
    id: 'dev_video_001',
    youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    youtubeId: 'dQw4w9WgXcQ',
    thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
    title: 'Epic Live Performance',
    artist: 'The Weeknd',
    artistId: 'dev_artist_001',
    description: 'Amazing live performance captured in NYC',
    genres: ['Pop', 'R&B'],
    location: {
      venue: 'Madison Square Garden',
      city: 'New York',
      country: 'USA',
      latitude: 40.7505,
      longitude: -73.9934,
    },
    duration: 240,
    publishedDate: new Date('2024-01-01'),
    recordedDate: new Date('2023-12-15'),
    status: 'published',
    likes: 1250,
    views: 45000,
    featured: true,
    sortOrder: 1,
    tags: ['live', 'concert', 'nyc'],
  },
  {
    id: 'dev_video_002',
    youtubeUrl: 'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
    youtubeId: '3JZ_D3ELwOQ',
    thumbnailUrl: 'https://img.youtube.com/vi/3JZ_D3ELwOQ/maxresdefault.jpg',
    title: 'Underground Session',
    artist: 'Daft Punk',
    artistId: 'dev_artist_002',
    description: 'Exclusive underground electronic set',
    genres: ['Electronic', 'House'],
    location: {
      venue: 'Warehouse 21',
      city: 'Berlin',
      country: 'Germany',
      latitude: 52.5200,
      longitude: 13.4050,
    },
    duration: 180,
    publishedDate: new Date('2024-01-02'),
    recordedDate: new Date('2023-12-20'),
    status: 'published',
    likes: 3400,
    views: 89000,
    featured: true,
    sortOrder: 2,
    tags: ['electronic', 'techno', 'berlin'],
  },
  {
    youtubeUrl: 'https://www.youtube.com/watch?v=kJQP7kiw5Fk',
    id: 'dev_video_003',
    youtubeId: 'kJQP7kiw5Fk',
    thumbnailUrl: 'https://img.youtube.com/vi/kJQP7kiw5Fk/maxresdefault.jpg',
    title: 'Acoustic Rooftop Session',
    artist: 'Billie Eilish',
    artistId: 'dev_artist_003',
    description: 'Intimate rooftop performance at sunset',
    genres: ['Indie', 'Pop'],
    location: {
      venue: 'Rooftop Studio',
      city: 'Los Angeles',
      country: 'USA',
      latitude: 34.0522,
      longitude: -118.2437,
    },
    duration: 195,
    publishedDate: new Date('2024-01-03'),
    recordedDate: new Date('2023-12-22'),
    status: 'published',
    likes: 2100,
    views: 67000,
    featured: true,
    sortOrder: 3,
    tags: ['acoustic', 'indie', 'sunset'],
  },
  {
    youtubeUrl: 'https://www.youtube.com/watch?v=fJ9rUzIMcZQ',
    id: 'dev_video_004',
    youtubeId: 'fJ9rUzIMcZQ',
    thumbnailUrl: 'https://img.youtube.com/vi/fJ9rUzIMcZQ/maxresdefault.jpg',
    title: 'Jazz Club Classics',
    artist: 'Robert Glasper',
    artistId: 'dev_artist_004',
    description: 'Classic jazz performance in an intimate club setting',
    genres: ['Jazz', 'Soul'],
    location: {
      venue: 'Blue Note',
      city: 'Tokyo',
      country: 'Japan',
      latitude: 35.6762,
      longitude: 139.6503,
    },
    duration: 220,
    publishedDate: new Date('2024-01-04'),
    recordedDate: new Date('2023-12-25'),
    status: 'published',
    likes: 890,
    views: 23000,
    featured: true,
    sortOrder: 4,
    tags: ['jazz', 'live', 'soul'],
  },
  {
    youtubeUrl: 'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
    id: 'dev_video_005',
    youtubeId: '2Vv-BfVoq4g',
    thumbnailUrl: 'https://img.youtube.com/vi/2Vv-BfVoq4g/maxresdefault.jpg',
    title: 'Festival Main Stage',
    artist: 'Travis Scott',
    artistId: 'dev_artist_005',
    description: 'High-energy festival performance',
    genres: ['Hip Hop', 'Rap'],
    location: {
      venue: 'Coachella',
      city: 'Indio',
      country: 'USA',
      latitude: 33.7175,
      longitude: -116.2156,
    },
    duration: 280,
    publishedDate: new Date('2024-01-05'),
    recordedDate: new Date('2023-12-28'),
    status: 'published',
    likes: 5600,
    views: 120000,
    featured: true,
    sortOrder: 5,
    tags: ['festival', 'hiphop', 'coachella'],
  },
  {
    id: 'dev_video_006',
    youtubeUrl: 'https://www.youtube.com/watch?v=zPjWtQKZPjY',
    youtubeId: 'zPjWtQKZPjY',
    thumbnailUrl: 'https://img.youtube.com/vi/zPjWtQKZPjY/maxresdefault.jpg',
    title: 'Live Drum & Bass Set',
    artist: 'Jack Slayton',
    artistId: 'dev_artist_006',
    description: 'Epic drum and bass live performance',
    genres: ['Electronic', 'Drum & Bass'],
    location: {
      venue: 'O2 Academy',
      city: 'London',
      country: 'UK',
      latitude: 51.5074,
      longitude: -0.1278,
    },
    duration: 300,
    publishedDate: new Date('2024-01-06'),
    recordedDate: new Date('2024-01-01'),
    status: 'published',
    likes: 4200,
    views: 95000,
    featured: true,
    sortOrder: 6,
    tags: ['dnb', 'electronic', 'live'],
  },
  {
    id: 'dev_video_007',
    youtubeUrl: 'https://www.youtube.com/watch?v=abc123def456',
    youtubeId: 'abc123def456',
    thumbnailUrl: 'https://img.youtube.com/vi/abc123def456/maxresdefault.jpg',
    title: 'Sunset Beach Session',
    artist: 'Khruangbin',
    artistId: 'dev_artist_007',
    description: 'Chill psychedelic groove on the beach',
    genres: ['Psychedelic', 'Funk'],
    location: {
      venue: 'Venice Beach',
      city: 'Los Angeles',
      country: 'USA',
      latitude: 33.9850,
      longitude: -118.4695,
    },
    duration: 210,
    publishedDate: new Date('2024-01-07'),
    recordedDate: new Date('2024-01-02'),
    status: 'published',
    likes: 1800,
    views: 42000,
    featured: false,
    sortOrder: 7,
    tags: ['psychedelic', 'beach', 'chill'],
  },
  {
    id: 'dev_video_008',
    youtubeUrl: 'https://www.youtube.com/watch?v=def456ghi789',
    youtubeId: 'def456ghi789',
    thumbnailUrl: 'https://img.youtube.com/vi/def456ghi789/maxresdefault.jpg',
    title: 'Basement Rap Cypher',
    artist: 'JID',
    artistId: 'dev_artist_008',
    description: 'Raw rap cypher with underground artists',
    genres: ['Hip Hop', 'Rap'],
    location: {
      venue: 'Underground Studio',
      city: 'Atlanta',
      country: 'USA',
      latitude: 33.7490,
      longitude: -84.3880,
    },
    duration: 165,
    publishedDate: new Date('2024-01-08'),
    recordedDate: new Date('2024-01-03'),
    status: 'published',
    likes: 3100,
    views: 78000,
    featured: false,
    sortOrder: 8,
    tags: ['rap', 'cypher', 'underground'],
  },
  {
    id: 'dev_video_009',
    youtubeUrl: 'https://www.youtube.com/watch?v=ghi789jkl012',
    youtubeId: 'ghi789jkl012',
    thumbnailUrl: 'https://img.youtube.com/vi/ghi789jkl012/maxresdefault.jpg',
    title: 'Orchestra Hall Performance',
    artist: 'Ludovico Einaudi',
    artistId: 'dev_artist_009',
    description: 'Beautiful classical piano performance',
    genres: ['Classical', 'Piano'],
    location: {
      venue: 'Royal Albert Hall',
      city: 'London',
      country: 'UK',
      latitude: 51.5009,
      longitude: -0.1773,
    },
    duration: 250,
    publishedDate: new Date('2024-01-09'),
    recordedDate: new Date('2024-01-04'),
    status: 'published',
    likes: 2500,
    views: 56000,
    featured: true,
    sortOrder: 9,
    tags: ['classical', 'piano', 'orchestral'],
  },
  {
    id: 'dev_video_010',
    youtubeUrl: 'https://www.youtube.com/watch?v=jkl012mno345',
    youtubeId: 'jkl012mno345',
    thumbnailUrl: 'https://img.youtube.com/vi/jkl012mno345/maxresdefault.jpg',
    title: 'Garage Rock Revival',
    artist: 'The Black Keys',
    artistId: 'dev_artist_010',
    description: 'High energy garage rock set',
    genres: ['Rock', 'Blues'],
    location: {
      venue: 'First Avenue',
      city: 'Minneapolis',
      country: 'USA',
      latitude: 44.9778,
      longitude: -93.2650,
    },
    duration: 200,
    publishedDate: new Date('2024-01-10'),
    recordedDate: new Date('2024-01-05'),
    status: 'published',
    likes: 1950,
    views: 48000,
    featured: false,
    sortOrder: 10,
    tags: ['rock', 'garage', 'blues'],
  },
  {
    id: 'dev_video_011',
    youtubeUrl: 'https://www.youtube.com/watch?v=mno345pqr678',
    youtubeId: 'mno345pqr678',
    thumbnailUrl: 'https://img.youtube.com/vi/mno345pqr678/maxresdefault.jpg',
    title: 'Afrobeat Festival Set',
    artist: 'Burna Boy',
    artistId: 'dev_artist_011',
    description: 'Energetic afrobeat performance',
    genres: ['Afrobeat', 'World'],
    location: {
      venue: 'Shrine',
      city: 'Lagos',
      country: 'Nigeria',
      latitude: 6.5244,
      longitude: 3.3792,
    },
    duration: 240,
    publishedDate: new Date('2024-01-11'),
    recordedDate: new Date('2024-01-06'),
    status: 'published',
    likes: 3800,
    views: 92000,
    featured: true,
    sortOrder: 11,
    tags: ['afrobeat', 'festival', 'world'],
  },
  {
    id: 'dev_video_012',
    youtubeUrl: 'https://www.youtube.com/watch?v=pqr678stu901',
    youtubeId: 'pqr678stu901',
    thumbnailUrl: 'https://img.youtube.com/vi/pqr678stu901/maxresdefault.jpg',
    title: 'Intimate Coffee Shop Set',
    artist: 'Norah Jones',
    artistId: 'dev_artist_012',
    description: 'Cozy coffee shop jazz performance',
    genres: ['Jazz', 'Blues'],
    location: {
      venue: 'Blue Note Cafe',
      city: 'New York',
      country: 'USA',
      latitude: 40.7282,
      longitude: -74.0776,
    },
    duration: 175,
    publishedDate: new Date('2024-01-12'),
    recordedDate: new Date('2024-01-07'),
    status: 'published',
    likes: 1400,
    views: 34000,
    featured: false,
    sortOrder: 12,
    tags: ['jazz', 'acoustic', 'intimate'],
  },
  {
    id: 'dev_video_013',
    youtubeUrl: 'https://www.youtube.com/watch?v=stu901vwx234',
    youtubeId: 'stu901vwx234',
    thumbnailUrl: 'https://img.youtube.com/vi/stu901vwx234/maxresdefault.jpg',
    title: 'Warehouse Techno Marathon',
    artist: 'Nina Kraviz',
    artistId: 'dev_artist_013',
    description: '6-hour techno marathon in Berlin warehouse',
    genres: ['Techno', 'Electronic'],
    location: {
      venue: 'Berghain',
      city: 'Berlin',
      country: 'Germany',
      latitude: 52.5105,
      longitude: 13.4426,
    },
    duration: 360,
    publishedDate: new Date('2024-01-13'),
    recordedDate: new Date('2024-01-08'),
    status: 'published',
    likes: 5200,
    views: 134000,
    featured: true,
    sortOrder: 13,
    tags: ['techno', 'warehouse', 'berlin'],
  },
  {
    id: 'dev_video_014',
    youtubeUrl: 'https://www.youtube.com/watch?v=vwx234yz567a',
    youtubeId: 'vwx234yz567a',
    thumbnailUrl: 'https://img.youtube.com/vi/vwx234yz567a/maxresdefault.jpg',
    title: 'Indie Folk Living Room',
    artist: 'Bon Iver',
    artistId: 'dev_artist_014',
    description: 'Intimate living room folk session',
    genres: ['Indie', 'Folk'],
    location: {
      venue: 'Private Studio',
      city: 'Portland',
      country: 'USA',
      latitude: 45.5152,
      longitude: -122.6784,
    },
    duration: 185,
    publishedDate: new Date('2024-01-14'),
    recordedDate: new Date('2024-01-09'),
    status: 'published',
    likes: 2700,
    views: 61000,
    featured: false,
    sortOrder: 14,
    tags: ['indie', 'folk', 'acoustic'],
  },
  {
    id: 'dev_video_015',
    youtubeUrl: 'https://www.youtube.com/watch?v=yz567abc890d',
    youtubeId: 'yz567abc890d',
    thumbnailUrl: 'https://img.youtube.com/vi/yz567abc890d/maxresdefault.jpg',
    title: 'Latin Jazz Fusion',
    artist: 'Chucho Valdés',
    artistId: 'dev_artist_015',
    description: 'Incredible Latin jazz fusion performance',
    genres: ['Jazz', 'Latin'],
    location: {
      venue: 'Ronnie Scott\'s',
      city: 'London',
      country: 'UK',
      latitude: 51.5136,
      longitude: -0.1321,
    },
    duration: 230,
    publishedDate: new Date('2024-01-15'),
    recordedDate: new Date('2024-01-10'),
    status: 'published',
    likes: 1650,
    views: 38000,
    featured: false,
    sortOrder: 15,
    tags: ['latin', 'jazz', 'fusion'],
  },
  {
    youtubeUrl: 'https://www.youtube.com/watch?v=XYZ123ABC',
    youtubeId: 'XYZ123ABC',
    id: 'dev_video_999',
    thumbnailUrl: 'https://img.youtube.com/vi/XYZ123ABC/maxresdefault.jpg',
    title: 'Unpublished Draft',
    artist: 'Test Artist',
    artistId: 'dev_artist_999',
    description: 'This is a draft video for testing',
    genres: ['Rock'],
    location: {
      venue: 'Test Venue',
      city: 'Test City',
      country: 'Test Country',
    },
    duration: 180,
    recordedDate: new Date('2024-01-10'),
    status: 'draft',
    likes: 0,
    views: 0,
    featured: false,
    sortOrder: 99,
    tags: ['test', 'draft'],
  },
];

// Test Artists
const testArtists = [
  {
    id: 'dev_artist_001',
    name: 'The Weeknd',
    bio: 'Canadian singer, songwriter, and record producer',
    genres: ['Pop', 'R&B'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=The+Weeknd&size=400&background=1a1a1a&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/weeknd/1200/400',
    location: 'Toronto, Canada',
    socialLinks: {
      instagram: 'https://instagram.com/theweeknd',
      twitter: 'https://twitter.com/theweeknd',
      spotify: 'https://open.spotify.com/artist/theweeknd'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_002',
    name: 'Daft Punk',
    bio: 'French electronic music duo',
    genres: ['Electronic', 'House'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Daft+Punk&size=400&background=2d2d2d&color=FFD700&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/daftpunk/1200/400',
    location: 'Paris, France',
    socialLinks: {
      instagram: 'https://instagram.com/daftpunk',
      spotify: 'https://open.spotify.com/artist/daftpunk'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_003',
    name: 'Billie Eilish',
    bio: 'American singer-songwriter',
    genres: ['Indie', 'Pop'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Billie+Eilish&size=400&background=00FF00&color=000000&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/billie/1200/400',
    location: 'Los Angeles, USA',
    socialLinks: {
      instagram: 'https://instagram.com/billieeilish',
      twitter: 'https://twitter.com/billieeilish',
      spotify: 'https://open.spotify.com/artist/billieeilish'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_004',
    name: 'Robert Glasper',
    bio: 'American pianist and record producer',
    genres: ['Jazz', 'Soul'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Robert+Glasper&size=400&background=8B4513&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/glasper/1200/400',
    location: 'Houston, USA',
    socialLinks: {
      instagram: 'https://instagram.com/robertglasper',
      spotify: 'https://open.spotify.com/artist/robertglasper'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_005',
    name: 'Travis Scott',
    bio: 'American rapper and producer',
    genres: ['Hip Hop', 'Rap'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Travis+Scott&size=400&background=8B0000&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/travis/1200/400',
    location: 'Houston, USA',
    socialLinks: {
      instagram: 'https://instagram.com/travisscott',
      twitter: 'https://twitter.com/travisscott',
      spotify: 'https://open.spotify.com/artist/travisscott'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_006',
    name: 'Jack Slayton',
    bio: 'Drum and bass DJ and producer',
    genres: ['Electronic', 'Drum & Bass'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Jack+Slayton&size=400&background=FF4500&color=000000&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/jackslayton/1200/400',
    location: 'London, UK',
    socialLinks: {
      instagram: 'https://instagram.com/jackslayton',
      twitter: 'https://twitter.com/jackslayton',
      spotify: 'https://open.spotify.com/artist/jackslayton'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_007',
    name: 'Khruangbin',
    bio: 'American psychedelic funk trio',
    genres: ['Psychedelic', 'Funk'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Khruangbin&size=400&background=FF1493&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/khruangbin/1200/400',
    location: 'Houston, USA',
    socialLinks: {
      instagram: 'https://instagram.com/khruangbin',
      twitter: 'https://twitter.com/khruangbin',
      spotify: 'https://open.spotify.com/artist/khruangbin'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_008',
    name: 'JID',
    bio: 'American rapper from Atlanta',
    genres: ['Hip Hop', 'Rap'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=JID&size=400&background=9370DB&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/jid/1200/400',
    location: 'Atlanta, USA',
    socialLinks: {
      instagram: 'https://instagram.com/jidsv',
      twitter: 'https://twitter.com/jidsv',
      spotify: 'https://open.spotify.com/artist/jid'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_009',
    name: 'Ludovico Einaudi',
    bio: 'Italian pianist and composer',
    genres: ['Classical', 'Piano'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Ludovico+Einaudi&size=400&background=4B0082&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/einaudi/1200/400',
    location: 'Turin, Italy',
    socialLinks: {
      instagram: 'https://instagram.com/ludovicoeinaudi',
      twitter: 'https://twitter.com/ludovicoeinaudi',
      spotify: 'https://open.spotify.com/artist/ludovicoeinaudi'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_010',
    name: 'The Black Keys',
    bio: 'American rock duo',
    genres: ['Rock', 'Blues'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=The+Black+Keys&size=400&background=2F4F4F&color=FFD700&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/blackkeys/1200/400',
    location: 'Akron, USA',
    socialLinks: {
      instagram: 'https://instagram.com/theblackkeys',
      twitter: 'https://twitter.com/theblackkeys',
      spotify: 'https://open.spotify.com/artist/theblackkeys'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_011',
    name: 'Burna Boy',
    bio: 'Nigerian afrobeat artist',
    genres: ['Afrobeat', 'World'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Burna+Boy&size=400&background=228B22&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/burnaboy/1200/400',
    location: 'Lagos, Nigeria',
    socialLinks: {
      instagram: 'https://instagram.com/burnaboygram',
      twitter: 'https://twitter.com/burnaboy',
      spotify: 'https://open.spotify.com/artist/burnaboy'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_012',
    name: 'Norah Jones',
    bio: 'American singer-songwriter and pianist',
    genres: ['Jazz', 'Blues'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Norah+Jones&size=400&background=800000&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/norah/1200/400',
    location: 'New York, USA',
    socialLinks: {
      instagram: 'https://instagram.com/norahjones',
      twitter: 'https://twitter.com/norahjones',
      spotify: 'https://open.spotify.com/artist/norahjones'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_013',
    name: 'Nina Kraviz',
    bio: 'Russian DJ and music producer',
    genres: ['Techno', 'Electronic'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Nina+Kraviz&size=400&background=000000&color=00CED1&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/ninakraviz/1200/400',
    location: 'Moscow, Russia',
    socialLinks: {
      instagram: 'https://instagram.com/ninakraviz',
      twitter: 'https://twitter.com/ninakraviz',
      spotify: 'https://open.spotify.com/artist/ninakraviz'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_014',
    name: 'Bon Iver',
    bio: 'American indie folk band',
    genres: ['Indie', 'Folk'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Bon+Iver&size=400&background=556B2F&color=F0E68C&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/boniver/1200/400',
    location: 'Eau Claire, USA',
    socialLinks: {
      instagram: 'https://instagram.com/boniver',
      twitter: 'https://twitter.com/boniver',
      spotify: 'https://open.spotify.com/artist/boniver'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_015',
    name: 'Chucho Valdés',
    bio: 'Cuban jazz pianist and composer',
    genres: ['Jazz', 'Latin'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Chucho+Valdes&size=400&background=CD853F&color=000000&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/chucho/1200/400',
    location: 'Havana, Cuba',
    socialLinks: {
      instagram: 'https://instagram.com/chuchovaldes',
      twitter: 'https://twitter.com/chuchovaldes',
      spotify: 'https://open.spotify.com/artist/chuchovaldes'
    },
    totalSets: 1,
    createdDate: new Date(),
    active: true,
  },
  {
    id: 'dev_artist_999',
    name: 'Test Artist',
    bio: 'Test artist for development',
    genres: ['Rock'],
    profileImageUrl: 'https://ui-avatars.com/api/?name=Test+Artist&size=400&background=808080&color=ffffff&bold=true',
    bannerImageUrl: 'https://picsum.photos/seed/test/1200/400',
    location: 'Test Location',
    socialLinks: {},
    totalSets: 1,
    createdDate: new Date(),
    active: false,
  },
];

// Test Users
const testUsers = [
  {
    uid: 'dev_test_user_001',
    email: 'test1@backdrp.fm',
    displayName: 'Test User 1',
    photoURL: 'https://via.placeholder.com/150?text=User1',
    bio: 'Music enthusiast and live session lover',
    createdAt: new Date(),
    savedVideos: ['dev_video_001', 'dev_video_003', 'dev_video_009'],
    followedArtists: ['dev_artist_001', 'dev_artist_003', 'dev_artist_009'],
    playlists: ['dev_playlist_001'],
  },
  {
    uid: 'dev_test_user_002',
    email: 'test2@backdrp.fm',
    displayName: 'Test User 2',
    photoURL: 'https://via.placeholder.com/150?text=User2',
    bio: 'Electronic music fan',
    createdAt: new Date(),
    savedVideos: ['dev_video_002', 'dev_video_005', 'dev_video_006', 'dev_video_013'],
    followedArtists: ['dev_artist_002', 'dev_artist_005', 'dev_artist_006', 'dev_artist_013'],
    playlists: ['dev_playlist_002'],
  },
  {
    uid: 'dev_test_user_003',
    email: 'test3@backdrp.fm',
    displayName: 'Jazz Lover',
    photoURL: 'https://via.placeholder.com/150?text=Jazz',
    bio: 'Jazz aficionado, always looking for new live sessions',
    createdAt: new Date(),
    savedVideos: ['dev_video_004', 'dev_video_012', 'dev_video_015'],
    followedArtists: ['dev_artist_004', 'dev_artist_012', 'dev_artist_015'],
    playlists: ['dev_playlist_003'],
  },
  {
    uid: 'dev_test_user_004',
    email: 'test4@backdrp.fm',
    displayName: 'Hip Hop Head',
    photoURL: 'https://via.placeholder.com/150?text=HipHop',
    bio: 'All about that underground rap scene',
    createdAt: new Date(),
    savedVideos: ['dev_video_005', 'dev_video_008'],
    followedArtists: ['dev_artist_005', 'dev_artist_008'],
    playlists: ['dev_playlist_004'],
  },
  {
    uid: 'dev_test_user_005',
    email: 'test5@backdrp.fm',
    displayName: 'World Music Explorer',
    photoURL: 'https://via.placeholder.com/150?text=World',
    bio: 'Exploring sounds from around the globe',
    createdAt: new Date(),
    savedVideos: ['dev_video_007', 'dev_video_011', 'dev_video_015'],
    followedArtists: ['dev_artist_007', 'dev_artist_011', 'dev_artist_015'],
    playlists: ['dev_playlist_005'],
  },
  {
    uid: 'dev_test_user_006',
    email: 'test6@backdrp.fm',
    displayName: 'Indie Enthusiast',
    photoURL: 'https://via.placeholder.com/150?text=Indie',
    bio: 'Chill vibes and indie sounds',
    createdAt: new Date(),
    savedVideos: ['dev_video_003', 'dev_video_014'],
    followedArtists: ['dev_artist_003', 'dev_artist_014'],
    playlists: [],
  },
];

// Test Playlists
const testPlaylists = [
  {
    id: 'dev_playlist_001',
    name: 'My Favorites',
    description: 'Collection of my favorite live performances',
    userId: 'dev_test_user_001',
    videoIds: ['dev_video_001', 'dev_video_003', 'dev_video_009'],
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'dev_playlist_002',
    name: 'Electronic Vibes',
    description: 'Best electronic live sets',
    userId: 'dev_test_user_002',
    videoIds: ['dev_video_002', 'dev_video_006', 'dev_video_013'],
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'dev_playlist_003',
    name: 'Jazz Sessions',
    description: 'Smooth jazz and soulful performances',
    userId: 'dev_test_user_003',
    videoIds: ['dev_video_004', 'dev_video_012', 'dev_video_015'],
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'dev_playlist_004',
    name: 'Hip Hop Heat',
    description: 'Fire rap performances and cyphers',
    userId: 'dev_test_user_004',
    videoIds: ['dev_video_005', 'dev_video_008'],
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'dev_playlist_005',
    name: 'Global Sounds',
    description: 'Music from around the world',
    userId: 'dev_test_user_005',
    videoIds: ['dev_video_007', 'dev_video_011', 'dev_video_015'],
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'dev_playlist_006',
    name: 'Late Night Chill',
    description: 'Perfect for late night vibes',
    userId: 'dev_test_user_001',
    videoIds: ['dev_video_003', 'dev_video_007', 'dev_video_012', 'dev_video_014'],
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

async function seedDatabase() {
  const envName = projectId.includes('staging') ? 'STAGING' : projectId.includes('prod') ? 'PRODUCTION' : 'DEVELOPMENT';
  console.log(`🌱 Starting to seed ${envName} database with comprehensive test data...\n`);

  try {
    const batch = db.batch();

    // Seed Videos
    console.log('📹 Seeding Videos:');
    testVideos.forEach((video) => {
      const { id, ...videoData } = video;
      const docRef = db.collection(COLLECTIONS.videos).doc(id);
      batch.set(docRef, videoData);
      console.log(`  ✓ ${video.title} (${video.status})`);
    });

    // Seed Artists
    console.log('\n🎤 Seeding Artists:');
    testArtists.forEach((artist) => {
      const docRef = db.collection(COLLECTIONS.artists).doc(artist.id);
      batch.set(docRef, artist);
      console.log(`  ✓ ${artist.name}`);
    });

    // Seed Users
    console.log('\n👤 Seeding Users:');
    testUsers.forEach((user) => {
      const docRef = db.collection(COLLECTIONS.users).doc(user.uid);
      batch.set(docRef, user);
      console.log(`  ✓ ${user.displayName} (${user.email})`);
    });

    // Seed Playlists
    console.log('\n📝 Seeding Playlists:');
    testPlaylists.forEach((playlist) => {
      const docRef = db.collection(COLLECTIONS.playlists).doc(playlist.id);
      batch.set(docRef, playlist);
      console.log(`  ✓ ${playlist.name}`);
    });

    console.log('\n📤 Committing batch write to Firestore...');
    await batch.commit();

    console.log(`\n✅ Successfully seeded ${envName} database!`);
    console.log('\n📊 Summary:');
    console.log(`   - Videos: ${testVideos.length}`);
    console.log(`   - Artists: ${testArtists.length}`);
    console.log(`   - Users: ${testUsers.length}`);
    console.log(`   - Playlists: ${testPlaylists.length}`);
    console.log(`\n🎉 Data seeded to collections: ${Object.values(COLLECTIONS).join(', ')}\n`);

    process.exit(0);
  } catch (error) {
    console.error('\n❌ Error seeding database:', error.message);
    process.exit(1);
  }
}

seedDatabase();
