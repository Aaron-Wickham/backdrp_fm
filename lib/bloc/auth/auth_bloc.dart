import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(const AuthInitial()) {
    // Register event handlers
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);

    // Listen to auth state changes
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        add(AuthLoggedIn(user.uid));
      } else {
        add(const AuthLoggedOut());
      }
    });
  }

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = _authService.currentUser;
      if (user != null) {
        final appUser = await _authService.getCurrentAppUser();
        if (appUser != null) {
          emit(AuthAuthenticated(appUser));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLoggedIn(
    AuthLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final appUser = await _authService.getCurrentAppUser();
      if (appUser != null) {
        emit(AuthAuthenticated(appUser));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUnauthenticated());
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final credential = await _authService.signUp(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );

      if (credential?.user != null) {
        final appUser = await _authService.getCurrentAppUser();
        if (appUser != null) {
          emit(AuthAuthenticated(appUser));
        } else {
          emit(const AuthError('Failed to create user profile'));
        }
      } else {
        emit(const AuthError('Sign up failed'));
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred during sign up';
      if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for this email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final credential = await _authService.signIn(
        email: event.email,
        password: event.password,
      );

      if (credential?.user != null) {
        final appUser = await _authService.getCurrentAppUser();
        if (appUser != null) {
          emit(AuthAuthenticated(appUser));
        } else {
          emit(const AuthError('Failed to load user profile'));
        }
      } else {
        emit(const AuthError('Login failed'));
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred during login';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled';
      }
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
