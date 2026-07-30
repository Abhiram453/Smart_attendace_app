import 'package:flutter/material.dart';
import '../data/models/ai_insight_model.dart';
import '../data/models/attendance_record_model.dart';
import '../data/services/ai_rule_engine_service.dart';

class AIInsightProvider extends ChangeNotifier {
  List<AIInsightModel> _studentInsights = [];
  List<AIInsightModel> _teacherInsights = [];

  List<AIInsightModel> get studentInsights => _studentInsights;
  List<AIInsightModel> get teacherInsights => _teacherInsights;

  void evaluateStudent(List<AttendanceRecordModel> records, {int totalSessions = 5}) {
    _studentInsights = AIRuleEngineService.evaluateStudentInsights(
      records,
      totalExpectedSessions: totalSessions,
    );
    notifyListeners();
  }

  void evaluateTeacherClass({
    required String className,
    required double attendancePercentage,
    required int totalStudents,
    required int absentCount,
  }) {
    _teacherInsights = AIRuleEngineService.evaluateTeacherInsights(
      className: className,
      attendancePercentage: attendancePercentage,
      totalStudents: totalStudents,
      absentCount: absentCount,
    );
    notifyListeners();
  }
}
