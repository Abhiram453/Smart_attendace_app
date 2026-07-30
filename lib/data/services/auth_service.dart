import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  // Real User Registration
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? studentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final newUser = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email.trim().toLowerCase(),
      role: role,
      studentId: studentId,
    );

    _currentUser = await _firestoreService.registerUser(newUser, password);
    return _currentUser!;
  }

  // Real User Login
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = await _firestoreService.authenticateUser(
      email.trim().toLowerCase(),
      password.trim(),
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}
