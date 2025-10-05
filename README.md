# BACKDRP.FM 🎵

> A minimalist platform for discovering and curating live music sessions, DJ sets, and performance videos

BACKDRP.FM is a Flutter-based application designed to be a centralized hub for live music content, helping users discover and explore their favorite artists' performances across various platforms while providing easy access to social media links and streaming services.

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud-FFCA28?logo=firebase)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-Private-red)]()

## 📱 Features

### Current Features
- **Video Discovery**: Browse curated live sessions, DJ sets, and performances
- **Artist Profiles**: Explore artist bios, genres, locations, and social links
- **Smart Search**: Search videos and artists by name, genre, or location
- **User Profiles**: Save favorite videos, like content, and manage preferences
- **Archive Filtering**: Filter content by genre, artist, and location
- **Video Playback**: Integrated YouTube player for seamless viewing
- **Social Sharing**: Share videos directly to social platforms
- **Responsive Design**: Works on iOS, Android, and Web

### Core Functionality
- 🎬 **Video Library**: Curated collection of live music performances
- 🎤 **Artist Directory**: Comprehensive artist profiles with social integration
- 🔍 **Advanced Search**: Multi-criteria search with real-time results
- 💾 **User Collections**: Save and organize favorite content
- 🎨 **Minimalist UI**: Clean black/white design with sharp edges and uppercase typography
- 📊 **Analytics**: Track views, likes, and engagement

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.9.2
- **State Management**: BLoC Pattern (flutter_bloc, hydrated_bloc)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Video Player**: youtube_player_flutter
- **Routing**: Flutter Navigator 2.0
- **Storage**: HydratedBloc for persistence

### Project Structure
```
lib/
├── bloc/                  # Business Logic Components
│   ├── auth/             # Authentication state management
│   ├── video/            # Video state management
│   ├── artist/           # Artist state management
│   ├── profile/          # User profile state management
│   └── navigation/       # App navigation state
├── models/               # Data models
│   ├── video.dart        # Video model with location
│   ├── artist.dart       # Artist profile model
│   ├── app_user.dart     # User model with preferences
│   └── playlist.dart     # Playlist model
├── screens/              # UI screens
│   ├── auth/            # Login & signup screens
│   ├── home_screen.dart  # Featured videos feed
│   ├── archive_screen.dart # Filterable video archive
│   ├── artists_screen.dart # Artist directory
│   ├── search_screen.dart  # Search interface
│   ├── video_detail_screen.dart # Video player & details
│   ├── artist_detail_screen.dart # Artist profile
│   └── profile_screen.dart # User profile & settings
├── services/             # Business logic & API calls
│   ├── auth_service.dart    # Firebase Auth integration
│   ├── video_service.dart   # Video CRUD operations
│   ├── artist_service.dart  # Artist CRUD operations
│   └── user_service.dart    # User profile management
├── widgets/              # Reusable components
│   ├── cards/           # Video & artist cards
│   ├── common/          # Loading, error, empty states
│   └── buttons/         # Custom button components
├── theme/                # Design system
│   ├── app_colors.dart   # Color palette
│   ├── app_typography.dart # Text styles
│   ├── app_spacing.dart  # Spacing constants
│   └── app_theme.dart    # Theme configuration
├── config/               # Configuration
│   └── environment.dart  # Environment-based configs
└── main.dart            # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.0 or higher
- Firebase account with project setup
- Node.js (for Firebase CLI and seeding)
- Code editor (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd backdrp_fm
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password)
   - Create Firestore database
   - Enable Firebase Storage
   - Download and configure Firebase config files:
     - iOS: `ios/Runner/GoogleService-Info.plist`
     - Android: `android/app/google-services.json`
     - Web: Auto-configured via FlutterFire CLI

4. **FlutterFire Configuration**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configure Firebase for your project
   flutterfire configure
   ```

5. **Firestore Indexes**
   ```bash
   # Deploy Firestore indexes
   firebase deploy --only firestore:indexes
   ```

6. **Seed Test Data** (Optional)
   ```bash
   # Seed development database with test data
   node seed-all-test-data.js
   ```

### Running the App

**Development Mode**
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web (Chrome)
flutter run -d chrome

# Web with debug
flutter run -d chrome --debug
```

**Production Build**
```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
flutter build appbundle --release

# Web
flutter build web --release
```

## 🔧 Configuration

### Environment Setup

The app uses environment-based collection names to separate dev and production data:

```dart
// lib/config/environment.dart
class AppEnvironment {
  static String getCollectionName(String baseCollection) {
    return 'dev_$baseCollection'; // or just baseCollection for production
  }
}
```

### Firebase Collections

**Development Collections:**
- `dev_videos` - Video metadata and details
- `dev_artists` - Artist profiles and information
- `dev_users` - User accounts and preferences
- `dev_playlists` - User-created playlists

**Production Collections:**
- `videos`, `artists`, `users`, `playlists`

### Admin Account

Admin access is granted to: `backdrp.fm@gmail.com`
- Full CRUD access to videos and artists
- User management capabilities
- Content moderation tools

## 🎨 Design System

### Color Palette
```dart
background: #000000        // Pure black
surface: #0A0A0A          // Slightly lighter black
textPrimary: #FFFFFF      // White
textSecondary: #B0B0B0    // Light gray
textTertiary: #666666     // Medium gray
secondary: #FFFFFF        // Accent (white on black)
border: #1A1A1A          // Subtle borders
```

### Typography
- All text is UPPERCASE with wide letter spacing (1.5-3.0)
- Primary font: System default with customized weights
- Headings: 700 weight, Body: 400-500 weight

### Design Principles
- **Minimalist**: Clean, distraction-free interface
- **High Contrast**: Pure black and white for readability
- **Sharp Edges**: No rounded corners (borderRadius: 0)
- **Consistent Spacing**: 4px, 8px, 12px, 16px, 24px, 32px increments

## 🧪 Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/artist_service_test.dart

# Run tests in watch mode
flutter test --watch
```

### Test Structure
```
test/
├── bloc/                 # BLoC unit tests
├── models/              # Model tests
├── services/            # Service integration tests
├── screens/             # Widget tests
└── mocks/               # Mock data and services
```

### Generate Mocks
```bash
# Generate mock files for testing
dart run build_runner build --delete-conflicting-outputs
```

## 📊 Database Schema

### Videos Collection
```typescript
{
  id: string,
  youtubeUrl: string,
  youtubeId: string,
  thumbnailUrl: string,
  title: string,
  artist: string,
  artistId: string,
  description: string,
  genres: string[],
  location: {
    venue: string,
    city: string,
    country: string,
    latitude?: number,
    longitude?: number
  },
  duration: number,
  recordedDate?: timestamp,
  publishedDate?: timestamp,
  status: 'draft' | 'published',
  likes: number,
  views: number,
  featured: boolean,
  sortOrder: number,
  tags: string[],
  soundcloudUrl?: string,
  spotifyPlaylistId?: string,
  appleMusicPlaylistId?: string
}
```

### Artists Collection
```typescript
{
  id: string,
  name: string,
  bio: string,
  profileImageUrl: string,
  bannerImageUrl: string,
  socialLinks: {
    [platform: string]: string
  },
  genres: string[],
  location: string,
  totalSets: number,
  createdDate?: timestamp,
  active: boolean
}
```

### Users Collection
```typescript
{
  uid: string,
  email: string,
  displayName: string,
  profileImageUrl: string,
  role: 'admin' | 'user',
  likedVideos: string[],
  savedVideos: string[],
  emailSubscribed: boolean,
  pushSubscribed: boolean,
  preferences: {
    favoriteGenres: string[],
    notificationPreferences: {
      newSets: boolean,
      artistUpdates: boolean,
      weeklyDigest: boolean
    }
  },
  createdDate?: timestamp,
  lastActive?: timestamp
}
```

## 🔐 Security Rules

See `firestore.rules` for detailed security configuration.

**Key Rules:**
- Users can read all published content
- Users can only write to their own user document
- Admin users have full write access
- Unauthenticated users have read-only access

## 🚧 Development Roadmap

### High Priority
- [ ] Add notification settings screen
- [ ] Add privacy settings screen
- [ ] Make archive filters dynamic (pull from Firestore)
- [ ] Add offline support/caching
- [ ] Implement proper logging framework
- [ ] Add crash reporting (Crashlytics/Sentry)

### Medium Priority
- [ ] Pagination for video/artist lists
- [ ] Search improvements (Algolia integration)
- [ ] OAuth providers (Google, Apple, Spotify)
- [ ] Email verification flow
- [ ] Watch time analytics

### Future Enhancements
- [ ] Comments/reactions system
- [ ] Watch history tracking
- [ ] Similar artists recommendations
- [ ] Tour dates integration
- [ ] Setlist/tracklist feature
- [ ] Deep linking support
- [ ] Multi-language support

See individual TODO comments in the codebase for detailed improvement opportunities (50+ TODOs documented).

## 📝 Scripts

### Database Seeding
```bash
# Seed all test data (videos, artists, users, playlists)
node seed-all-test-data.js

# Seed specific collections
node seed-data.js
node seed-firestore.js
```

### Firebase Deployment
```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Firestore indexes
firebase deploy --only firestore:indexes

# Deploy all
firebase deploy
```

## 🤝 Contributing

This is a private project. For internal team members:

1. Create a feature branch from `main`
2. Make your changes with clear commit messages
3. Run tests: `flutter test`
4. Push and create a pull request
5. Request code review

### Code Style
- Follow Flutter/Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused
- Write tests for new features

## 🐛 Known Issues

- Web: YouTube player autoplay may be blocked by browser policies
- iOS: Requires proper code signing for physical device deployment
- Search: Client-side filtering can be slow with large datasets (needs Algolia)

See GitHub Issues for full list and status updates.

## 📄 License

This project is private and proprietary. All rights reserved.

## 👥 Team

**Project Lead**: Aaron Wickham
**Contact**: backdrp.fm@gmail.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- The open-source community for excellent packages
- All contributing artists and content creators

---

**Built with ❤️ for the music community**

For detailed setup instructions, see [DEV_SETUP.md](DEV_SETUP.md)
