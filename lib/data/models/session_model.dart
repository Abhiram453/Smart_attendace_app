class SessionModel {
  final String sessionId;
  final String classId;
  final String qrPayload;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isActive;

  SessionModel({
    required this.sessionId,
    required this.classId,
    required this.qrPayload,
    required this.createdAt,
    required this.expiresAt,
    this.isActive = true,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'] ?? '',
      classId: json['classId'] ?? '',
      qrPayload: json['qrPayload'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      expiresAt: DateTime.tryParse(json['expiresAt'] ?? '') ?? DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'classId': classId,
      'qrPayload': qrPayload,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
