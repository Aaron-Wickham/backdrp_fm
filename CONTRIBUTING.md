# Contributing to BACKDRP.FM

Thank you for your interest in contributing to BACKDRP.FM! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing Requirements](#testing-requirements)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

- Be respectful and professional
- Provide constructive feedback
- Focus on the code, not the person
- Help create a welcoming environment for all contributors

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- Flutter SDK 3.9.2+
- Dart SDK 3.0+
- Node.js 16+
- Firebase CLI
- Git
- Code editor (VS Code recommended)

### Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/backdrp_fm.git
   cd backdrp_fm
   ```

2. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/Aaron-Wickham/backdrp_fm.git
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   npm install
   ```

4. **Set up environment files**
   ```bash
   cp .env.example .env.development
   # Edit .env.development with your dev Firebase project details
   ```

5. **Run the app**
   ```bash
   flutter run -d chrome
   ```

## Development Workflow

### Branch Strategy

We use a feature branch workflow:

- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/*` - New features
- `fix/*` - Bug fixes
- `refactor/*` - Code refactoring
- `docs/*` - Documentation updates

### Creating a Feature Branch

```bash
# Make sure you're on develop and up to date
git checkout develop
git pull upstream develop

# Create a new feature branch
git checkout -b feature/your-feature-name
```

### Making Changes

1. **Always work in development environment**
   ```bash
   flutter run  # defaults to development
   ```

2. **Make your changes following our code standards**

3. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit your changes** (see [Commit Guidelines](#commit-guidelines))

5. **Keep your branch updated**
   ```bash
   git fetch upstream
   git rebase upstream/develop
   ```

### Running Different Environments

```bash
# Development (for testing)
flutter run --dart-define=ENVIRONMENT=development

# Staging (for QA testing)
flutter run --dart-define=ENVIRONMENT=staging

# Production (testing prod build)
flutter run --dart-define=ENVIRONMENT=production --release
```

## Code Standards

### Dart Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

```dart
// Good
class VideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback onTap;

  const VideoCard({
    super.key,
    required this.video,
    required this.onTap,
  });
}

// Bad
class videoCard extends StatelessWidget{
  Video video;
  var onTap;
  videoCard(this.video,this.onTap);
}
```

### File Organization

```
lib/
├── bloc/           # Business logic
├── models/         # Data models
├── screens/        # UI screens
├── services/       # API services
├── widgets/        # Reusable widgets
├── theme/          # Design system
└── config/         # Configuration
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private members**: `_leadingUnderscore`

```dart
// Files
video_detail_screen.dart
artist_service.dart

// Classes
class VideoBloc {}
class ArtistCard {}

// Variables/Functions
final String videoTitle;
void loadVideos() {}

// Constants
const int MAX_VIDEOS = 100;
const String API_KEY = 'xxx';

// Private
String _userId;
void _handleError() {}
```

### BLoC Pattern

We use the BLoC pattern for state management:

```dart
// Events
abstract class VideoEvent extends Equatable {
  const VideoEvent();
}

class LoadVideos extends VideoEvent {
  const LoadVideos();

  @override
  List<Object> get props => [];
}

// States
abstract class VideoState extends Equatable {
  const VideoState();
}

class VideoLoading extends VideoState {
  @override
  List<Object> get props => [];
}

class VideoLoaded extends VideoState {
  final List<Video> videos;

  const VideoLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}

// BLoC
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoService _videoService;

  VideoBloc({required VideoService videoService})
    : _videoService = videoService,
      super(VideoInitial()) {
    on<LoadVideos>(_onLoadVideos);
  }

  Future<void> _onLoadVideos(
    LoadVideos event,
    Emitter<VideoState> emit,
  ) async {
    emit(VideoLoading());
    try {
      final videos = await _videoService.getVideos();
      emit(VideoLoaded(videos));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
```

### Documentation

Add documentation for:
- Public classes and methods
- Complex logic
- Non-obvious code

```dart
/// Fetches videos from Firestore based on the current environment.
///
/// Returns a list of published videos sorted by [sortOrder].
/// Throws [FirebaseException] if the fetch fails.
Future<List<Video>> getVideos() async {
  // Implementation
}
```

### Error Handling

Always handle errors gracefully:

```dart
// Good
try {
  final videos = await _videoService.getVideos();
  emit(VideoLoaded(videos));
} catch (e) {
  emit(VideoError('Failed to load videos: ${e.toString()}'));
}

// Bad
final videos = await _videoService.getVideos(); // Unhandled exception
```

## Testing Requirements

### Test Coverage

- **Minimum coverage**: 80% for new features
- **Required tests**:
  - Unit tests for BLoCs
  - Unit tests for models
  - Widget tests for screens
  - Integration tests for critical flows

### Writing Tests

```dart
// BLoC test example
blocTest<VideoBloc, VideoState>(
  'emits [VideoLoading, VideoLoaded] when LoadVideos succeeds',
  build: () {
    when(() => mockVideoService.getVideos())
        .thenAnswer((_) async => mockVideos);
    return VideoBloc(videoService: mockVideoService);
  },
  act: (bloc) => bloc.add(const LoadVideos()),
  expect: () => [
    VideoLoading(),
    VideoLoaded(mockVideos),
  ],
);

// Widget test example
testWidgets('VideoCard displays video title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: VideoCard(
        video: testVideo,
        onTap: () {},
      ),
    ),
  );

  expect(find.text(testVideo.title), findsOneWidget);
});
```

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/bloc/video/video_bloc_test.dart

# Run tests in watch mode
flutter test --watch
```

### Before Submitting

Ensure all checks pass:

```bash
# Run tests
flutter test

# Check code quality
flutter analyze

# Format code
dart format lib/ test/

# Generate test coverage
flutter test --coverage
```

## Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples

```bash
# Feature
git commit -m "feat(video): add video sharing functionality"

# Bug fix
git commit -m "fix(auth): resolve login error with empty email"

# Documentation
git commit -m "docs(readme): update installation instructions"

# Refactor
git commit -m "refactor(bloc): simplify video state management"

# Test
git commit -m "test(artist): add tests for artist detail screen"
```

### Detailed Commit

```
feat(video): add video sharing functionality

- Implement share button on video detail screen
- Add social sharing service
- Support Twitter, Facebook, and native share
- Add analytics tracking for shares

Closes #123
```

## Pull Request Process

### Before Creating a PR

1. **Update your branch**
   ```bash
   git fetch upstream
   git rebase upstream/develop
   ```

2. **Run all checks**
   ```bash
   flutter test
   flutter analyze
   dart format lib/ test/
   ```

3. **Test in multiple environments**
   ```bash
   flutter run --dart-define=ENVIRONMENT=development
   flutter run --dart-define=ENVIRONMENT=staging
   ```

### Creating a PR

1. **Push your branch**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create PR on GitHub**
   - Go to repository on GitHub
   - Click "New Pull Request"
   - Select `develop` as base branch
   - Select your feature branch

3. **Fill out PR template**

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] All tests pass
- [ ] Added new tests for new features
- [ ] Tested in development environment
- [ ] Tested in staging environment

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed code
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] No new warnings
- [ ] Added tests with good coverage
- [ ] All tests pass
```

### PR Review Process

1. **Automated checks** must pass:
   - Tests
   - Code analysis
   - Build

2. **Code review** by maintainers
   - At least 1 approval required
   - Address all review comments

3. **Merge**
   - Squash and merge to `develop`
   - Delete feature branch

## Project Structure

### Key Directories

```
lib/
├── bloc/                    # BLoC state management
│   ├── auth/
│   ├── video/
│   ├── artist/
│   ├── profile/
│   └── navigation/
├── models/                  # Data models
│   ├── video.dart
│   ├── artist.dart
│   ├── app_user.dart
│   └── playlist.dart
├── screens/                 # UI screens
│   ├── auth/
│   ├── settings/
│   └── *.dart
├── services/                # Business logic
│   ├── auth_service.dart
│   ├── video_service.dart
│   ├── artist_service.dart
│   └── user_service.dart
├── widgets/                 # Reusable widgets
│   ├── buttons/
│   ├── cards/
│   ├── common/
│   └── inputs/
├── theme/                   # Design system
│   ├── app_colors.dart
│   ├── app_typography.dart
│   ├── app_spacing.dart
│   └── app_theme.dart
├── config/                  # Configuration
│   └── environment.dart
└── main.dart               # Entry point
```

## Common Tasks

### Adding a New Screen

1. Create screen file in `lib/screens/`
2. Create corresponding tests in `test/screens/`
3. Add navigation in `NavigationBloc`
4. Update routes if needed

### Adding a New BLoC

1. Create BLoC directory in `lib/bloc/`
2. Create event, state, and bloc files
3. Create tests in `test/bloc/`
4. Register in `ServiceProvider` if needed

### Adding a New Service

1. Create service file in `lib/services/`
2. Add to `ServiceProvider`
3. Create tests in `test/services/`
4. Update models if needed

### Updating Firestore Schema

1. Update model in `lib/models/`
2. Update service methods
3. Update Firestore rules if needed
4. Update seed scripts
5. Add migration script if needed
6. Update tests

## Environment-Specific Development

### Working with Dev Environment

```bash
# Run app
flutter run

# Deploy Firestore rules
firebase use backdrp-fm-dev
firebase deploy --only firestore

# Seed data
node seed-all-test-data.js --project=backdrp-fm-dev
```

### Testing in Staging

```bash
# Run app
flutter run --dart-define=ENVIRONMENT=staging

# Deploy
firebase use backdrp-fm-staging
firebase deploy --only firestore
```

## Getting Help

- **Documentation**: Check [README.md](README.md) and [ENVIRONMENT_SETUP.md](ENVIRONMENT_SETUP.md)
- **Issues**: Search existing issues or create a new one
- **Discussions**: Use GitHub Discussions for questions
- **Code Review**: Request review from maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Thank you for contributing to BACKDRP.FM!** 🎵
