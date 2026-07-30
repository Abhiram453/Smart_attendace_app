enum UserRole { teacher, student }

class UserModel {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final String? profilePicUrl;
  final String? studentId;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.profilePicUrl,
    this.studentId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] == 'teacher' ? UserRole.teacher : UserRole.student,
      profilePicUrl: json['profilePicUrl'],
      studentId: json['studentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role == UserRole.teacher ? 'teacher' : 'student',
      'profilePicUrl': profilePicUrl,
      'studentId': studentId,
    };
  }
}
