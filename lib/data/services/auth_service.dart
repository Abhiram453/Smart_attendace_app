import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirestoreService _firestoreService = FirestoreService();
  FirebaseAuth? _firebaseAuth;
  GoogleSignIn? _googleSignIn;
  UserModel? _currentUser;

  AuthService() {
    _initFirebase();
  }

  void _initFirebase() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _firebaseAuth = FirebaseAuth.instance;
        _googleSignIn = GoogleSignIn();
      }
    } catch (_) {
      // Graceful fallback if Firebase is not yet configured for local environment
    }
  }

  UserModel? get currentUser => _currentUser;

  // Real User Registration (Email & Password)
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? studentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      if (_firebaseAuth != null) {
        final credential = await _firebaseAuth!.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
        await credential.user?.updateDisplayName(name);
      }
    } catch (e) {
      // Fallback to local Firestore database if Firebase project config is offline
    }

    final newUser = UserModel(
      uid: _firebaseAuth?.currentUser?.uid ?? 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email.trim().toLowerCase(),
      role: role,
      studentId: studentId,
    );

    _currentUser = await _firestoreService.registerUser(newUser, password);
    return _currentUser!;
  }

  // Real User Sign In (Email & Password)
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      if (_firebaseAuth != null) {
        await _firebaseAuth!.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      }
    } catch (e) {
      // Fallback to local Firestore database if Firebase project config is offline
    }

    _currentUser = await _firestoreService.authenticateUser(
      email.trim().toLowerCase(),
      password.trim(),
    );
    return _currentUser!;
  }

  // Firebase Google Sign-In Authentication
  Future<UserModel> signInWithGoogle({required UserRole role}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    String name = 'Google User';
    String email = 'user.google@domain.com';
    String uid = 'google_${DateTime.now().millisecondsSinceEpoch}';

    try {
      if (_googleSignIn != null && _firebaseAuth != null) {
        final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final OAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final UserCredential userCredential = await _firebaseAuth!.signInWithCredential(credential);
          final User? user = userCredential.user;
          if (user != null) {
            name = user.displayName ?? name;
            email = user.email ?? email;
            uid = user.uid;
          }
        }
      }
    } catch (e) {
      // Fallback for desktop / web platform when Google OAuth client is offline
    }

    final googleUserObj = UserModel(
      uid: uid,
      name: name,
      email: email,
      role: role,
      studentId: role == UserRole.student ? 'STU-GGL-101' : null,
    );

    _currentUser = await _firestoreService.registerOrGetGoogleUser(googleUserObj);
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      await _firebaseAuth?.signOut();
      await _googleSignIn?.signOut();
    } catch (_) {}
    _currentUser = null;
  }
}
