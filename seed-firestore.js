// Simple script to seed Firestore with test data
const admin = require('firebase-admin');
const serviceAccount = require('./functions/service-account-key.json');

// Initialize with service account
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'backdrop-fm'
});

const db = admin.firestore();

const testVideos = [
  {
    youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    youtubeId: 'dQw4w9WgXcQ',
    thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/maxresdefault.jpg',
    title: 'Epic Live Performance',
    artist: 'The Weeknd',
    artistId: 'artist_001',
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
    youtubeUrl: 'https://www.youtube.com/watch?v=3JZ_D3ELwOQ',
    youtubeId: '3JZ_D3ELwOQ',
    thumbnailUrl: 'https://img.youtube.com/vi/3JZ_D3ELwOQ/maxresdefault.jpg',
    title: 'Underground Session',
    artist: 'Daft Punk',
    artistId: 'artist_002',
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
    youtubeId: 'kJQP7kiw5Fk',
    thumbnailUrl: 'https://img.youtube.com/vi/kJQP7kiw5Fk/maxresdefault.jpg',
    title: 'Acoustic Rooftop Session',
    artist: 'Billie Eilish',
    artistId: 'artist_003',
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
    youtubeId: 'fJ9rUzIMcZQ',
    thumbnailUrl: 'https://img.youtube.com/vi/fJ9rUzIMcZQ/maxresdefault.jpg',
    title: 'Jazz Club Classics',
    artist: 'Robert Glasper',
    artistId: 'artist_004',
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
    youtubeId: '2Vv-BfVoq4g',
    thumbnailUrl: 'https://img.youtube.com/vi/2Vv-BfVoq4g/maxresdefault.jpg',
    title: 'Festival Main Stage',
    artist: 'Travis Scott',
    artistId: 'artist_005',
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
];

async function seedDatabase() {
  console.log('🌱 Starting to seed database with test videos...\n');

  try {
    // Use batch write for efficiency
    const batch = db.batch();

    testVideos.forEach((video, index) => {
      const docRef = db.collection('videos').doc();
      batch.set(docRef, video);
      console.log(`  ✓ Queued: ${video.title} (${video.artist})`);
    });

    console.log('\n📤 Committing batch write to Firestore...');
    await batch.commit();

    console.log('\n✅ Successfully seeded ' + testVideos.length + ' test videos!');
    console.log('🎉 Your app should now display videos on the home screen.\n');

    process.exit(0);
  } catch (error) {
    console.error('\n❌ Error seeding database:', error.message);
    console.error('\n💡 Make sure you are logged in with: firebase login');
    process.exit(1);
  }
}

// Run the seed function
seedDatabase();
