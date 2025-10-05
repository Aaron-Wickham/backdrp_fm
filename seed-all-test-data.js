// Comprehensive test data seeding script
const admin = require('firebase-admin');
const serviceAccount = require('./functions/service-account-key.json');

// Parse command line arguments
const args = process.argv.slice(2);
const projectFlag = args.find(arg => arg.startsWith('--project='));
const projectId = projectFlag ? projectFlag.split('=')[1] : 'backdrp-fm-dev';

// Determine environment prefix based on project
let envPrefix = 'dev_';
if (projectId.includes('staging')) {
  envPrefix = 'staging_';
} else if (projectId.includes('prod')) {
  envPrefix = '';
}

console.log(`🔧 Initializing Firebase Admin SDK for project: ${projectId}`);
console.log(`📝 Using collection prefix: "${envPrefix}"`);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: projectId
});

const db = admin.firestore();

// Use environment-appropriate prefix for all collections
const COLLECTIONS = {
  videos: `${envPrefix}videos`,
  users: `${envPrefix}users`,
  artists: `${envPrefix}artists`,
  playlists: `${envPrefix}playlists`
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
    youtubeUrl: 'https://www.youtube.com/watch?v=XYZ123ABC',
    youtubeId: 'XYZ123ABC',
    id: 'dev_video_006',
    thumbnailUrl: 'https://img.youtube.com/vi/XYZ123ABC/maxresdefault.jpg',
    title: 'Unpublished Draft',
    artist: 'Test Artist',
    artistId: 'dev_artist_006',
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
    savedVideos: ['video_001', 'video_003'],
    followedArtists: ['dev_artist_001', 'dev_artist_003'],
    playlists: ['dev_playlist_001'],
  },
  {
    uid: 'dev_test_user_002',
    email: 'test2@backdrp.fm',
    displayName: 'Test User 2',
    photoURL: 'https://via.placeholder.com/150?text=User2',
    bio: 'Electronic music fan',
    createdAt: new Date(),
    savedVideos: ['video_002', 'video_005'],
    followedArtists: ['dev_artist_002', 'dev_artist_005'],
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
    videoIds: ['video_001', 'video_003', 'video_004'],
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'dev_playlist_002',
    name: 'Electronic Vibes',
    description: 'Best electronic live sets',
    userId: 'dev_test_user_002',
    videoIds: ['video_002'],
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

async function seedDatabase() {
  const envName = envPrefix ? envPrefix.replace('_', '').toUpperCase() : 'PRODUCTION';
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
