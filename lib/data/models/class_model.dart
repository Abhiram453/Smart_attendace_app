class ClassModel {
  final String id;
  final String title;
  final String subjectCode;
  final String roomNumber;
  final String teacherId;
  final String teacherName;
  final int totalEnrolledStudents;
  final List<String> enrolledStudentIds;

  ClassModel({
    required this.id,
    required this.title,
    required this.subjectCode,
    required this.roomNumber,
    required this.teacherId,
    required this.teacherName,
    required this.totalEnrolledStudents,
    this.enrolledStudentIds = const [],
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subjectCode: json['subjectCode'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      teacherId: json['teacherId'] ?? '',
      teacherName: json['teacherName'] ?? '',
      totalEnrolledStudents: json['totalEnrolledStudents'] ?? 0,
      enrolledStudentIds: List<String>.from(json['enrolledStudentIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subjectCode': subjectCode,
      'roomNumber': roomNumber,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'totalEnrolledStudents': totalEnrolledStudents,
      'enrolledStudentIds': enrolledStudentIds,
    };
  }
}
