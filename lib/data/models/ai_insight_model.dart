enum AIInsightType { lowAttendanceWarning, streakReward, teacherRecommendation, info }

class AIInsightModel {
  final String id;
  final String title;
  final String description;
  final AIInsightType type;
  final DateTime timestamp;
  final String? targetId; // classId or studentId
  final String actionText;

  AIInsightModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.targetId,
    required this.actionText,
  });
}
