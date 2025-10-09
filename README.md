# BACKDRP.FM 🎵

> A minimalist platform for discovering and curating live music sessions, DJ sets, and performance videos

BACKDRP.FM is a Flutter-based application designed to be a centralized hub for live music content, helping users discover and explore their favorite artists' performances across various platforms while providing easy access to social media links and streaming services.

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Multi--Environment-FFCA28?logo=firebase)](https://firebase.google.com/)
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
- **Multi-Environment**: Separate dev, staging, and production environments
- **Responsive Design**: Works on iOS, Android, and Web

## 🏗️ Architecture

### Tech Stack
- **Framework**: Flutter 3.9.2
- **State Management**: BLoC Pattern (flutter_bloc, hydrated_bloc)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Video Player**: youtube_player_flutter
- **Storage**: HydratedBloc for persistence
- **Environment Management**: flutter_dotenv with multi-environment support

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
│   ├── settings/        # Settings screens (notifications, privacy)
│   └── *.dart           # Main app screens
├── services/             # Business logic & API calls
│   ├── auth_service.dart    # Firebase Auth integration
│   ├── video_service.dart   # Video CRUD operations
│   ├── artist_service.dart  # Artist CRUD operations
│   └── user_service.dart    # User profile management
├── widgets/              # Reusable components
├── theme/                # Design system
├── config/               # Configuration
│   └── environment.dart  # Multi-environment configs
└── main.dart            # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.0 or higher
- Firebase account with projects for dev/staging/prod
- Node.js 16+ (for Firebase CLI and seeding)
- Code editor (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Aaron-Wickham/backdrp_fm.git
   cd backdrp_fm
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment files**
   ```bash
   cp .env.example .env.development
   cp .env.example .env.staging
   cp .env.example .env.production

   # Edit each file with your Firebase project IDs
   ```

4. **Install Node dependencies** (for seed scripts)
   ```bash
   npm install
   ```

### Firebase Setup

The app uses **three separate Firebase projects** for complete environment isolation:

- `backdrp-fm-dev` - Development
- `backdrp-fm-staging` - Staging/QA
- `backdrop-fm` - Production

**Firebase configuration files** (already generated):
- `lib/firebase_options_dev.dart`
- `lib/firebase_options_staging.dart`
- `lib/firebase_options_prod.dart`

**Download service account keys for seeding:**

1. Download service account keys from Firebase Console:
   - Dev: https://console.firebase.google.com/project/backdrp-fm-dev/settings/serviceaccounts/adminsdk
   - Staging: https://console.firebase.google.com/project/backdrp-fm-staging/settings/serviceaccounts/adminsdk
   - Prod: https://console.firebase.google.com/project/backdrop-fm/settings/serviceaccounts/adminsdk

2. Save keys to `functions/` directory:
   ```
   functions/service-account-key-dev.json
   functions/service-account-key-staging.json
   functions/service-account-key.json
   ```

**Deploy Firestore rules and indexes to all environments:**
```bash
# Development
firebase deploy --only firestore --project backdrp-fm-dev

# Staging
firebase deploy --only firestore --project backdrp-fm-staging

# Production
firebase deploy --only firestore --project backdrop-fm
```

### Running the App

**Development Mode** (default)
```bash
flutter run -d chrome
# or
flutter run -d ios
# or
flutter run -d android
```

**Staging Mode**
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=staging
```

**Production Mode**
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=production
```

### Seed Test Data

**Using npm scripts (recommended):**
```bash
# Seed development environment
npm run seed:dev

# Seed staging environment
npm run seed:staging

# Seed production (use with caution!)
npm run seed:prod
```

**Using Node directly:**
```bash
# Seed development environment
node seed-all-test-data.js --project=backdrp-fm-dev

# Seed staging environment
node seed-all-test-data.js --project=backdrp-fm-staging

# Seed production
node seed-all-test-data.js --project=backdrop-fm
```

This creates:
- 6 test videos (5 published, 1 draft)
- 5 test artists (The Weeknd, Daft Punk, Billie Eilish, Robert Glasper, Travis Scott)
- 2 test users
- 2 test playlists

**Note:** The seed script automatically uses the correct service account key and collection prefix based on the project ID.

## 🔧 Configuration

### Environment Variables

The app automatically loads environment-specific configuration:

- `.env.development` - Dev settings (analytics OFF)
- `.env.staging` - Staging settings (analytics ON)
- `.env.production` - Prod settings (all features ON)

### Firestore Collections

Each environment uses separate collections for complete data isolation:

| Environment | Collection Prefix | Example |
|-------------|------------------|---------|
| Development | `dev_` | `dev_videos`, `dev_artists` |
| Staging | `staging_` | `staging_videos`, `staging_artists` |
| Production | _(none)_ | `videos`, `artists` |

### Environment Indicators

In debug mode, you'll see a banner showing the current environment:
- 🟢 **DEVELOPMENT** (green banner)
- 🟠 **STAGING** (orange banner)
- 🔴 **PRODUCTION** (red banner, only in debug)

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

### Design Principles
- **Minimalist**: Clean, distraction-free interface
- **High Contrast**: Pure black and white for readability
- **Sharp Edges**: No rounded corners (borderRadius: 0)
- **Consistent Spacing**: 4px, 8px, 12px, 16px, 24px, 32px increments
- **UPPERCASE Typography**: All text uppercase with wide letter spacing

## 🧪 Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/artist_service_test.dart
```

### Test Coverage
- **179/181 tests passing** (98.9% pass rate)
- Comprehensive BLoC tests
- Model serialization tests
- Widget interaction tests
- Authentication flow tests

See [TEST_COVERAGE_SUMMARY.md](TEST_COVERAGE_SUMMARY.md) for detailed breakdown.

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
  tags: string[]
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

See [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md) for complete schema details.

## 🔐 Security

### Firestore Rules
- Separate rules for `dev_*`, `staging_*`, and production collections
- Published content readable by all
- Writes restricted to authenticated users
- Admin role required for content management

### Security Best Practices
- Environment files in `.gitignore`
- Firebase config files in `.gitignore`
- Separate Firebase projects per environment
- No sensitive keys committed to repository

## 📖 Documentation

- [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md) - Multi-environment configuration guide
- [TEST_COVERAGE_SUMMARY.md](TEST_COVERAGE_SUMMARY.md) - Testing documentation
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines

## 🚧 Roadmap

### High Priority
- [ ] Add Firebase Crashlytics
- [ ] Implement proper logging framework
- [ ] Add CI/CD pipeline (GitHub Actions)
- [ ] Implement pagination for video/artist lists
- [ ] Add offline support/caching

### Medium Priority
- [ ] Search improvements (Algolia integration)
- [ ] OAuth providers (Google, Apple, Spotify)
- [ ] Email verification flow
- [ ] Watch time analytics

### Future Enhancements
- [ ] Comments/reactions system
- [ ] Watch history tracking
- [ ] Similar artists recommendations
- [ ] Tour dates integration
- [ ] Deep linking support
- [ ] Multi-language support

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow and guidelines.

## 📝 Scripts

### Firebase Deployment
```bash
# Deploy to specific environment
firebase deploy --only firestore --project backdrp-fm-dev
firebase deploy --only firestore --project backdrp-fm-staging
firebase deploy --only firestore --project backdrop-fm
```

### Database Seeding
```bash
# Using npm scripts (recommended)
npm run seed:dev
npm run seed:staging
npm run seed:prod

# Using Node directly
node seed-all-test-data.js --project=backdrp-fm-dev
node seed-all-test-data.js --project=backdrp-fm-staging
node seed-all-test-data.js --project=backdrop-fm
```

## 📄 License

This project is private and proprietary. All rights reserved.

## 👥 Team

**Project Lead**: Aaron Wickham
**Contact**: backdrp.fm@gmail.com
**Repository**: https://github.com/Aaron-Wickham/backdrp_fm

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- The open-source community for excellent packages
- All contributing artists and content creators

---

**Built with ❤️ for the music community**
