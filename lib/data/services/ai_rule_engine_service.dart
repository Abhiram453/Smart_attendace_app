import '../models/attendance_record_model.dart';
import '../models/ai_insight_model.dart';

class AIRuleEngineService {
  // Evaluates Student Records & Generates AI Insights & Smart Warnings
  static List<AIInsightModel> evaluateStudentInsights(
    List<AttendanceRecordModel> records, {
    required int totalExpectedSessions,
  }) {
    List<AIInsightModel> insights = [];

    if (records.isEmpty) {
      insights.add(
        AIInsightModel(
          id: 'ai_init',
          title: 'AI Smart Start',
          description: 'Scan your first QR code to start tracking your attendance analytics and unlocking streak badges!',
          type: AIInsightType.info,
          timestamp: DateTime.now(),
          actionText: 'Scan QR Code',
        ),
      );
      return insights;
    }

    int presentCount = records.where((r) => r.status == AttendanceStatus.present || r.status == AttendanceStatus.late).length;
    double percentage = totalExpectedSessions > 0
        ? (presentCount / totalExpectedSessions) * 100
        : (presentCount / records.length) * 100;

    // RULE 1: Low Attendance Alert (< 75%)
    if (percentage < 75.0) {
      insights.add(
        AIInsightModel(
          id: 'ai_low_att_${DateTime.now().millisecondsSinceEpoch}',
          title: '⚠️ AI Risk Warning: Attendance Below 75%',
          description:
              'Your current overall attendance is ${percentage.toStringAsFixed(1)}%. AI predicts a potential exam eligibility risk if 2 more classes are missed.',
          type: AIInsightType.lowAttendanceWarning,
          timestamp: DateTime.now(),
          actionText: 'View Remedial Plan',
        ),
      );
    }

    // RULE 2: Consecutive Absence Warning
    int consecutiveAbsences = 0;
    for (var r in records) {
      if (r.status == AttendanceStatus.absent) {
        consecutiveAbsences++;
      } else {
        break;
      }
    }

    if (consecutiveAbsences >= 2) {
      insights.add(
        AIInsightModel(
          id: 'ai_consec_abs',
          title: '🚨 AI Alert: Consecutive Absences Detected',
          description:
              'You have missed $consecutiveAbsences consecutive sessions. Your instructor has been automatically notified.',
          type: AIInsightType.lowAttendanceWarning,
          timestamp: DateTime.now(),
          actionText: 'Contact Teacher',
        ),
      );
    }

    // RULE 3: Perfect Attendance Streak Reward (>= 90% or 3+ consecutive presents)
    int streak = 0;
    for (var r in records) {
      if (r.status == AttendanceStatus.present) {
        streak++;
      } else {
        break;
      }
    }

    if (streak >= 3 || percentage >= 90.0) {
      insights.add(
        AIInsightModel(
          id: 'ai_streak_reward',
          title: '🌟 AI Star Student Badge Unlocked!',
          description:
              'Outstanding commitment! You have maintained a $streak-session present streak ($percentage% average). Keep it up!',
          type: AIInsightType.streakReward,
          timestamp: DateTime.now(),
          actionText: 'Claim Badge',
        ),
      );
    }

    return insights;
  }

  // Evaluates Class Statistics for Teacher Recommendations
  static List<AIInsightModel> evaluateTeacherInsights({
    required String className,
    required double attendancePercentage,
    required int totalStudents,
    required int absentCount,
  }) {
    List<AIInsightModel> insights = [];

    if (attendancePercentage < 70.0) {
      insights.add(
        AIInsightModel(
          id: 'ai_t_low',
          title: '📉 AI Class Alert: Declining Engagement',
          description:
              'Attendance for $className has dropped to ${attendancePercentage.toStringAsFixed(1)}%. $absentCount students are currently absent.',
          type: AIInsightType.teacherRecommendation,
          timestamp: DateTime.now(),
          actionText: 'Send Automated Alert',
        ),
      );
    } else {
      insights.add(
        AIInsightModel(
          id: 'ai_t_good',
          title: '✅ AI Insight: High Class Engagement',
          description:
              '$className maintains a strong ${attendancePercentage.toStringAsFixed(1)}% attendance rate. Dynamic QR session window is optimal.',
          type: AIInsightType.info,
          timestamp: DateTime.now(),
          actionText: 'Export Report',
        ),
      );
    }

    return insights;
  }
}
