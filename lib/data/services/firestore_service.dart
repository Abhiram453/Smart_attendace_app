import '../models/class_model.dart';
import '../models/session_model.dart';
import '../models/attendance_record_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  // Real registered users database
  final List<UserModel> _users = [
    UserModel(
      uid: 'teacher_101',
      name: 'Dr. Sarah Jenkins',
      email: 'sarah@university.edu',
      role: UserRole.teacher,
    ),
    UserModel(
      uid: 'student_201',
      name: 'Alex Rivera',
      email: 'alex@student.edu',
      role: UserRole.student,
      studentId: 'STU-89210',
    ),
  ];

  final Map<String, String> _passwords = {
    'sarah@university.edu': 'password123',
    'alex@student.edu': 'password123',
  };

  // Register New User
  Future<UserModel> registerUser(UserModel user, String password) async {
    final existingIndex = _users.indexWhere((u) => u.email.toLowerCase() == user.email.toLowerCase());
    if (existingIndex != -1) {
      throw Exception('An account with email "${user.email}" already exists. Please sign in.');
    }
    _users.add(user);
    _passwords[user.email.toLowerCase()] = password;
    return user;
  }

  // Register or Retrieve Google OAuth User
  Future<UserModel> registerOrGetGoogleUser(UserModel user) async {
    final existingIndex = _users.indexWhere((u) => u.email.toLowerCase() == user.email.toLowerCase());
    if (existingIndex != -1) {
      return _users[existingIndex];
    }
    _users.add(user);
    return user;
  }

  // Authenticate User
  Future<UserModel> authenticateUser(String email, String password) async {
    final userIndex = _users.indexWhere((u) => u.email.toLowerCase() == email.toLowerCase());
    if (userIndex == -1) {
      throw Exception('No account found for "$email". Please create an account first.');
    }
    final storedPassword = _passwords[email.toLowerCase()];
    if (storedPassword != password) {
      throw Exception('Incorrect password. Please double check and try again.');
    }
    return _users[userIndex];
  }

  // In-memory classes database
  final List<ClassModel> _classes = [
    ClassModel(
      id: 'cls_1',
      title: 'Advanced Mobile App Dev (CS401)',
      subjectCode: 'CS401',
      roomNumber: 'Lab 304',
      teacherId: 'teacher_101',
      teacherName: 'Dr. Sarah Jenkins',
      totalEnrolledStudents: 42,
      enrolledStudentIds: ['student_201'],
    ),
    ClassModel(
      id: 'cls_2',
      title: 'Artificial Intelligence & ML (CS405)',
      subjectCode: 'CS405',
      roomNumber: 'Auditorium B',
      teacherId: 'teacher_101',
      teacherName: 'Dr. Sarah Jenkins',
      totalEnrolledStudents: 55,
      enrolledStudentIds: ['student_201'],
    ),
  ];

  final List<SessionModel> _sessions = [];

  final List<AttendanceRecordModel> _attendanceRecords = [];

  // Fetch classes for teacher
  Future<List<ClassModel>> getTeacherClasses(String teacherId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _classes.where((c) => c.teacherId == teacherId).toList();
  }

  // Fetch classes for student
  Future<List<ClassModel>> getStudentClasses(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _classes;
  }

  // Create Class
  Future<ClassModel> createClass(ClassModel newClass) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _classes.add(newClass);
    return newClass;
  }

  // Delete Class
  Future<void> deleteClass(String classId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _classes.removeWhere((c) => c.id == classId);
  }

  // Generate QR Session
  Future<SessionModel> createQRSession(String classId, int durationMinutes) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final session = SessionModel(
      sessionId: 'ses_${now.millisecondsSinceEpoch}',
      classId: classId,
      qrPayload: 'SMART_ATTENDANCE_${classId}_${now.millisecondsSinceEpoch}',
      createdAt: now,
      expiresAt: now.add(Duration(minutes: durationMinutes)),
      isActive: true,
    );
    _sessions.add(session);
    return session;
  }

  // Deactivate Session
  Future<void> endSession(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _sessions.indexWhere((s) => s.sessionId == sessionId);
    if (index != -1) {
      final old = _sessions[index];
      _sessions[index] = SessionModel(
        sessionId: old.sessionId,
        classId: old.classId,
        qrPayload: old.qrPayload,
        createdAt: old.createdAt,
        expiresAt: DateTime.now(),
        isActive: false,
      );
    }
  }

  // Record Attendance
  Future<AttendanceRecordModel> markAttendance({
    required String qrPayload,
    required String studentId,
    required String studentName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Find matching session
    final sessionIndex = _sessions.indexWhere(
      (s) => s.qrPayload.trim() == qrPayload.trim() || qrPayload.contains(s.classId),
    );

    String classId = 'cls_1';
    String className = 'Advanced Mobile App Dev (CS401)';
    String sessionId = 'ses_active_1';

    if (sessionIndex != -1) {
      final s = _sessions[sessionIndex];
      if (s.isExpired) {
        throw Exception("This QR Session has expired! Ask your teacher to refresh the QR code.");
      }
      classId = s.classId;
      sessionId = s.sessionId;
      final cls = _classes.firstWhere((c) => c.id == classId, orElse: () => _classes.first);
      className = cls.title;
    }

    // Check duplicate
    final existingIndex = _attendanceRecords.indexWhere(
      (r) => r.sessionId == sessionId && r.studentId == studentId,
    );
    if (existingIndex != -1) {
      throw Exception("You have already logged your attendance for this session!");
    }

    final newRecord = AttendanceRecordModel(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      classId: classId,
      className: className,
      studentId: studentId,
      studentName: studentName,
      timestamp: DateTime.now(),
      status: AttendanceStatus.present,
    );

    _attendanceRecords.insert(0, newRecord);
    return newRecord;
  }

  // Fetch Attendance Records
  Future<List<AttendanceRecordModel>> getStudentAttendanceRecords(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _attendanceRecords.where((r) => r.studentId == studentId).toList();
  }

  Future<List<AttendanceRecordModel>> getClassAttendanceRecords(String classId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _attendanceRecords.where((r) => r.classId == classId).toList();
  }
}
