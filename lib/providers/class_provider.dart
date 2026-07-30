import 'package:flutter/material.dart';
import '../data/models/class_model.dart';
import '../data/models/session_model.dart';
import '../data/services/firestore_service.dart';

class ClassProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<ClassModel> _classes = [];
  SessionModel? _activeSession;
  bool _isLoading = false;
  String? _errorMessage;

  List<ClassModel> get classes => _classes;
  SessionModel? get activeSession => _activeSession;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTeacherClasses(String teacherId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _classes = await _firestoreService.getTeacherClasses(teacherId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStudentClasses(String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _classes = await _firestoreService.getStudentClasses(studentId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createClass({
    required String title,
    required String subjectCode,
    required String roomNumber,
    required String teacherId,
    required String teacherName,
    required int totalEnrolledStudents,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newClass = ClassModel(
        id: 'cls_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        subjectCode: subjectCode,
        roomNumber: roomNumber,
        teacherId: teacherId,
        teacherName: teacherName,
        totalEnrolledStudents: totalEnrolledStudents,
      );
      final created = await _firestoreService.createClass(newClass);
      _classes.add(created);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteClass(String classId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestoreService.deleteClass(classId);
      _classes.removeWhere((c) => c.id == classId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<SessionModel?> generateQRSession(String classId, {int durationMinutes = 15}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _activeSession = await _firestoreService.createQRSession(classId, durationMinutes);
      _isLoading = false;
      notifyListeners();
      return _activeSession;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> endActiveSession() async {
    if (_activeSession != null) {
      await _firestoreService.endSession(_activeSession!.sessionId);
      _activeSession = null;
      notifyListeners();
    }
  }
}
