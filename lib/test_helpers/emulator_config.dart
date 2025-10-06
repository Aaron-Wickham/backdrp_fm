import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Configure Firebase to use local emulators for testing
void useFirebaseEmulators() {
  // Auth Emulator
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  // Firestore Emulator
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  // Storage Emulator
  FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
}
