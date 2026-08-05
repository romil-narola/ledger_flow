import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/firebase_options.dart';

/// Centralized service to manage Firebase authentication & Firestore access.
class FirebaseService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  User? get currentUser => isInitialized ? auth.currentUser : null;
  String? get currentUserId => currentUser?.uid;

  /// Initializes Firebase and configures Cloud Firestore offline persistence settings.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Configure Firestore offline persistence & settings
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _isInitialized = true;
      debugPrint('[FirebaseService] Successfully initialized Firebase.');
    } catch (e) {
      debugPrint('[FirebaseService] Initialization notice: $e');
      // Set initialized to true for offline / mock mode compatibility
      _isInitialized = true;
    }
  }

  /// Ensures user is authenticated (using Anonymous auth if no active login session exists).
  Future<User?> ensureAuthenticated() async {
    await initialize();

    try {
      if (auth.currentUser != null) {
        return auth.currentUser;
      }

      final userCredential = await auth.signInAnonymously();
      debugPrint(
          '[FirebaseService] Signed in anonymously with UID: ${userCredential.user?.uid}');
      return userCredential.user;
    } catch (e) {
      debugPrint('[FirebaseService] Auth sign-in warning: $e');
      try {
        return auth.currentUser;
      } catch (_) {
        return null;
      }
    }
  }

  /// Performs Google Sign-In and links credential to Firebase Auth.
  Future<UserCredential?> signInWithGoogle() async {
    await initialize();
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            '242049436022-bjb7vvbrn64322hln8kobv92vcda0073.apps.googleusercontent.com',
      );

      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.signIn();
      } catch (e) {
        debugPrint('[FirebaseService] Primary GoogleSignIn attempt notice: $e');
        // Fallback without serverClientId if Android native plugin uses google-services.json
        googleSignIn = GoogleSignIn();
        googleUser = await googleSignIn.signIn();
      }

      if (googleUser == null) return null; // User cancelled flow

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      debugPrint(
          '[FirebaseService] Google Sign-In success: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      debugPrint('[FirebaseService] Google Sign-In error: $e');
      rethrow;
    }
  }

  /// Signs out current Firebase session and Google account.
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await auth.signOut();
    } catch (e) {
      debugPrint('[FirebaseService] Sign-out warning: $e');
    }
  }

  /// Returns user's root Firestore document reference.
  DocumentReference<Map<String, dynamic>>? getUserDocumentRef([String? uid]) {
    final userId = uid ?? currentUserId;
    if (userId == null) return null;
    return firestore.collection('users').doc(userId);
  }

  /// Returns Firestore collection reference for a specified user sub-collection.
  CollectionReference<Map<String, dynamic>>? getUserCollection(
    String collectionName, {
    String? uid,
  }) {
    final userRef = getUserDocumentRef(uid);
    return userRef?.collection(collectionName);
  }
}
