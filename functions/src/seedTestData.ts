import * as admin from 'firebase-admin';

// Initialize admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

export async function seedTestVideos() {
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
      publishedDate: admin.firestore.FieldValue.serverTimestamp(),
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
      publishedDate: admin.firestore.FieldValue.serverTimestamp(),
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
      publishedDate: admin.firestore.FieldValue.serverTimestamp(),
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
      publishedDate: admin.firestore.FieldValue.serverTimestamp(),
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
      publishedDate: admin.firestore.FieldValue.serverTimestamp(),
      status: 'published',
      likes: 5600,
      views: 120000,
      featured: true,
      sortOrder: 5,
      tags: ['festival', 'hiphop', 'coachella'],
    },
  ];

  const batch = db.batch();

  testVideos.forEach((video) => {
    const docRef = db.collection('videos').doc();
    batch.set(docRef, video);
  });

  await batch.commit();
  console.log('✅ Successfully seeded test videos!');
}

// Run the seed function
seedTestVideos()
  .then(() => {
    console.log('✅ Seeding complete!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Error seeding data:', error);
    process.exit(1);
  });
