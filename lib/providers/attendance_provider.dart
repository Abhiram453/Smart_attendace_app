import 'package:flutter/material.dart';
import '../data/models/attendance_record_model.dart';
import '../data/services/firestore_service.dart';

class AttendanceProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<AttendanceRecordModel> _records = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AttendanceRecordModel> get records => _records;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get overallAttendancePercentage {
    if (_records.isEmpty) return 100.0;
    int present = _records.where((r) => r.status == AttendanceStatus.present || r.status == AttendanceStatus.late).length;
    return (present / _records.length) * 100;
  }

  Future<void> fetchStudentRecords(String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _records = await _firestoreService.getStudentAttendanceRecords(studentId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchClassRecords(String classId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _records = await _firestoreService.getClassAttendanceRecords(classId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AttendanceRecordModel?> markAttendance({
    required String qrPayload,
    required String studentId,
    required String studentName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final record = await _firestoreService.markAttendance(
        qrPayload: qrPayload,
        studentId: studentId,
        studentName: studentName,
      );
      _records.insert(0, record);
      _isLoading = false;
      notifyListeners();
      return record;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
