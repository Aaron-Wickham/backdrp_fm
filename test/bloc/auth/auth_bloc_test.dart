import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:backdrp_fm/bloc/auth/auth_bloc.dart';
import 'package:backdrp_fm/bloc/auth/auth_event.dart';
import 'package:backdrp_fm/bloc/auth/auth_state.dart';
import 'package:backdrp_fm/services/auth_service.dart';
import 'package:backdrp_fm/models/app_user.dart';

@GenerateMocks([AuthService, User, UserCredential])
import 'auth_bloc_test.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthService mockAuthService;
  late AppUser testUser;

  setUp(() {
    mockAuthService = MockAuthService();
    testUser = AppUser(
      uid: 'test-uid',
      email: 'test@example.com',
      displayName: 'Test User',
      role: UserRole.user,
    );

    // Mock the authStateChanges stream to return a never-ending stream
    when(mockAuthService.authStateChanges).thenAnswer((_) => Stream.value(null));

    authBloc = AuthBloc(authService: mockAuthService);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial or AuthUnauthenticated', () {
      // The state can be AuthInitial or AuthUnauthenticated depending on the stream
      expect(authBloc.state, anyOf(const AuthInitial(), const AuthUnauthenticated()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AuthStarted succeeds with user',
      build: () {
        final mockUser = MockUser();
        when(mockAuthService.currentUser).thenReturn(mockUser);
        when(mockAuthService.getCurrentAppUser())
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when AuthStarted with no user',
      build: () {
        when(mockAuthService.currentUser).thenReturn(null);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when AuthStarted fails',
      build: () {
        when(mockAuthService.currentUser).thenThrow(Exception('Error'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        final mockUser = MockUser();
        final mockCredential = MockUserCredential();
        when(mockCredential.user).thenReturn(mockUser);
        when(mockAuthService.signIn(
          email: 'test@example.com',
          password: 'password123',
        )).thenAnswer((_) async => mockCredential);
        when(mockAuthService.getCurrentAppUser())
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails with wrong password',
      build: () {
        when(mockAuthService.signIn(
          email: 'test@example.com',
          password: 'wrong',
        )).thenThrow(
          FirebaseAuthException(code: 'wrong-password'),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'wrong',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthError('Wrong password'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails with user not found',
      build: () {
        when(mockAuthService.signIn(
          email: 'notfound@example.com',
          password: 'password123',
        )).thenThrow(
          FirebaseAuthException(code: 'user-not-found'),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'notfound@example.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthError('No user found with this email'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when signup succeeds',
      build: () {
        final mockUser = MockUser();
        final mockCredential = MockUserCredential();
        when(mockCredential.user).thenReturn(mockUser);
        when(mockAuthService.signUp(
          email: 'new@example.com',
          password: 'password123',
          displayName: 'New User',
        )).thenAnswer((_) async => mockCredential);
        when(mockAuthService.getCurrentAppUser())
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignUpRequested(
        email: 'new@example.com',
        password: 'password123',
        displayName: 'New User',
      )),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when signup fails with weak password',
      build: () {
        when(mockAuthService.signUp(
          email: 'new@example.com',
          password: 'weak',
          displayName: 'New User',
        )).thenThrow(
          FirebaseAuthException(code: 'weak-password'),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignUpRequested(
        email: 'new@example.com',
        password: 'weak',
        displayName: 'New User',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthError('The password is too weak'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when signup fails with email already in use',
      build: () {
        when(mockAuthService.signUp(
          email: 'existing@example.com',
          password: 'password123',
          displayName: 'New User',
        )).thenThrow(
          FirebaseAuthException(code: 'email-already-in-use'),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignUpRequested(
        email: 'existing@example.com',
        password: 'password123',
        displayName: 'New User',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthError('An account already exists for this email'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when AuthLoggedOut is added',
      build: () {
        when(mockAuthService.authStateChanges).thenAnswer((_) => Stream.value(null));
        return AuthBloc(authService: mockAuthService);
      },
      act: (bloc) => bloc.add(const AuthLoggedOut()),
      expect: () => [
        const AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when AuthLoggedIn succeeds',
      build: () {
        when(mockAuthService.getCurrentAppUser())
            .thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoggedIn('test-uid')),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(testUser),
      ],
    );
  });

  group('AuthState', () {
    test('AuthAuthenticated isAdmin returns true for admin user', () {
      final adminUser = AppUser(
        uid: 'admin-uid',
        email: 'admin@example.com',
        role: UserRole.admin,
      );
      final state = AuthAuthenticated(adminUser);

      expect(state.isAdmin, true);
    });

    test('AuthAuthenticated isAdmin returns false for regular user', () {
      final state = AuthAuthenticated(testUser);

      expect(state.isAdmin, false);
    });
  });
}
