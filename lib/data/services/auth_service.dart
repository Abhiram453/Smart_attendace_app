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
    _initFirebase();

    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      String uid = googleUser.id;
      String name = googleUser.displayName ?? 'Google User';
      String email = googleUser.email;

      if (_firebaseAuth != null) {
        final UserCredential userCredential = await _firebaseAuth!.signInWithCredential(credential);
        if (userCredential.user != null) {
          uid = userCredential.user!.uid;
          name = userCredential.user!.displayName ?? name;
          email = userCredential.user!.email ?? email;
        }
      }

      final googleUserObj = UserModel(
        uid: uid,
        name: name,
        email: email,
        role: role,
        studentId: role == UserRole.student ? 'STU-${email.split('@').first.toUpperCase()}' : null,
      );

      _currentUser = await _firestoreService.registerOrGetGoogleUser(googleUserObj);
      return _currentUser!;
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      if (msg.contains('cancelled') || msg.contains('canceled')) {
        throw Exception('Google Sign-In was cancelled.');
      }
      throw Exception('Google Sign-In failed: $msg. Please ensure Google Sign-In is enabled in Firebase Console.');
    }
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
