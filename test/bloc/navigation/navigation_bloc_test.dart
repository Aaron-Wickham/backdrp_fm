import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:backdrp_fm/bloc/navigation/navigation_bloc.dart';
import 'package:backdrp_fm/bloc/navigation/navigation_event.dart';
import 'package:backdrp_fm/bloc/navigation/navigation_state.dart';

void main() {
  late NavigationBloc navigationBloc;

  setUp(() {
    navigationBloc = NavigationBloc();
  });

  tearDown(() {
    navigationBloc.close();
  });

  group('NavigationBloc', () {
    test('initial state is NavigationHome', () {
      expect(navigationBloc.state, const NavigationHome());
    });

    blocTest<NavigationBloc, NavigationState>(
      'emits NavigationHome when NavigateToHome is added',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const NavigateToHome()),
      expect: () => [const NavigationHome()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits NavigationArchive when NavigateToArchive is added',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const NavigateToArchive()),
      expect: () => [const NavigationArchive()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits NavigationArtists when NavigateToArtists is added',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const NavigateToArtists()),
      expect: () => [const NavigationArtists()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits NavigationProfile when NavigateToProfile is added',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const NavigateToProfile()),
      expect: () => [const NavigationProfile()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits NavigationDetail when NavigateToVideo is added',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const NavigateToVideo('video123')),
      expect: () => [
        const NavigationDetail(
          type: NavigationType.video,
          id: 'video123',
          previousIndex: 0,
        ),
      ],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits NavigationDetail when NavigateToArtist is added',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const NavigateToArtist('artist123')),
      expect: () => [
        const NavigationDetail(
          type: NavigationType.artist,
          id: 'artist123',
          previousIndex: 0,
        ),
      ],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits NavigationDetail when NavigateToPlaylist is added',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const NavigateToPlaylist('playlist123')),
      expect: () => [
        const NavigationDetail(
          type: NavigationType.playlist,
          id: 'playlist123',
          previousIndex: 0,
        ),
      ],
    );

    blocTest<NavigationBloc, NavigationState>(
      'preserves previousIndex when navigating to detail',
      build: () => NavigationBloc(),
      seed: () => const NavigationArchive(),
      act: (bloc) => bloc.add(const NavigateToVideo('video123')),
      expect: () => [
        const NavigationDetail(
          type: NavigationType.video,
          id: 'video123',
          previousIndex: 1,
        ),
      ],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits NavigationSettings when NavigateToSettings is added',
      build: () => NavigationBloc(),
      seed: () => const NavigationArchive(),
      act: (bloc) => bloc.add(const NavigateToSettings()),
      expect: () => [
        const NavigationSettings(previousIndex: 1),
      ],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits previous index state when NavigateBack from detail',
      build: () => NavigationBloc(),
      seed: () => const NavigationDetail(
        type: NavigationType.video,
        id: 'video123',
        previousIndex: 2,
      ),
      act: (bloc) => bloc.add(const NavigateBack()),
      expect: () => [const NavigationArtists()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'emits previous index state when NavigateBack from settings',
      build: () => NavigationBloc(),
      seed: () => const NavigationSettings(previousIndex: 3),
      act: (bloc) => bloc.add(const NavigateBack()),
      expect: () => [const NavigationProfile()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'stays on NavigationHome when NavigateBack from home',
      build: () => NavigationBloc(),
      seed: () => const NavigationHome(),
      act: (bloc) => bloc.add(const NavigateBack()),
      expect: () => [],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles deep link to video',
      build: () => NavigationBloc(),
      act: (bloc) =>
          bloc.add(const HandleDeepLink('https://app.com/video/video123')),
      expect: () => [
        const NavigationDetail(
          type: NavigationType.video,
          id: 'video123',
          previousIndex: 0,
        ),
      ],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles deep link to artist',
      build: () => NavigationBloc(),
      act: (bloc) =>
          bloc.add(const HandleDeepLink('https://app.com/artist/artist123')),
      expect: () => [
        const NavigationDetail(
          type: NavigationType.artist,
          id: 'artist123',
          previousIndex: 0,
        ),
      ],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles deep link to playlist',
      build: () => NavigationBloc(),
      act: (bloc) => bloc
          .add(const HandleDeepLink('https://app.com/playlist/playlist123')),
      expect: () => [
        const NavigationDetail(
          type: NavigationType.playlist,
          id: 'playlist123',
          previousIndex: 0,
        ),
      ],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles deep link to home',
      build: () => NavigationBloc(),
      seed: () => const NavigationArchive(),
      act: (bloc) => bloc.add(const HandleDeepLink('https://app.com/home')),
      expect: () => [const NavigationHome()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles deep link to archive',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const HandleDeepLink('https://app.com/archive')),
      expect: () => [const NavigationArchive()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles deep link to artists',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const HandleDeepLink('https://app.com/artists')),
      expect: () => [const NavigationArtists()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles deep link to profile',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const HandleDeepLink('https://app.com/profile')),
      expect: () => [const NavigationProfile()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles invalid deep link by navigating to home',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const HandleDeepLink('https://app.com/unknown')),
      expect: () => [const NavigationHome()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'handles empty deep link path',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const HandleDeepLink('https://app.com/')),
      expect: () => [],
    );

    blocTest<NavigationBloc, NavigationState>(
      'navigates to home when SetCurrentIndex(0)',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const SetCurrentIndex(0)),
      expect: () => [const NavigationHome()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'navigates to archive when SetCurrentIndex(1)',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const SetCurrentIndex(1)),
      expect: () => [const NavigationArchive()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'navigates to artists when SetCurrentIndex(2)',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const SetCurrentIndex(2)),
      expect: () => [const NavigationArtists()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'navigates to profile when SetCurrentIndex(3)',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const SetCurrentIndex(3)),
      expect: () => [const NavigationProfile()],
    );

    blocTest<NavigationBloc, NavigationState>(
      'navigates to home when SetCurrentIndex with invalid index',
      build: () => NavigationBloc(),
      act: (bloc) => bloc.add(const SetCurrentIndex(99)),
      expect: () => [const NavigationHome()],
    );
  });

  group('NavigationState', () {
    test('NavigationHome has currentIndex 0', () {
      expect(const NavigationHome().currentIndex, 0);
    });

    test('NavigationArchive has currentIndex 1', () {
      expect(const NavigationArchive().currentIndex, 1);
    });

    test('NavigationArtists has currentIndex 2', () {
      expect(const NavigationArtists().currentIndex, 2);
    });

    test('NavigationProfile has currentIndex 3', () {
      expect(const NavigationProfile().currentIndex, 3);
    });

    test('NavigationDetail preserves previousIndex as currentIndex', () {
      const state = NavigationDetail(
        type: NavigationType.video,
        id: 'video123',
        previousIndex: 2,
      );
      expect(state.currentIndex, 2);
    });

    test('NavigationSettings preserves previousIndex as currentIndex', () {
      const state = NavigationSettings(previousIndex: 1);
      expect(state.currentIndex, 1);
    });
  });
}
