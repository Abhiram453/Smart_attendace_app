enum AttendanceStatus { present, late, absent }

class AttendanceRecordModel {
  final String id;
  final String sessionId;
  final String classId;
  final String className;
  final String studentId;
  final String studentName;
  final DateTime timestamp;
  final AttendanceStatus status;

  AttendanceRecordModel({
    required this.id,
    required this.sessionId,
    required this.classId,
    required this.className,
    required this.studentId,
    required this.studentName,
    required this.timestamp,
    required this.status,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'] ?? '',
      sessionId: json['sessionId'] ?? '',
      classId: json['classId'] ?? '',
      className: json['className'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      status: json['status'] == 'present'
          ? AttendanceStatus.present
          : json['status'] == 'late'
              ? AttendanceStatus.late
              : AttendanceStatus.absent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'classId': classId,
      'className': className,
      'studentId': studentId,
      'studentName': studentName,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }
}
