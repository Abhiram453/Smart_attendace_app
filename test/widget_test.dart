import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smart_attendance_app/main.dart';
import 'package:smart_attendance_app/providers/ai_insight_provider.dart';
import 'package:smart_attendance_app/providers/attendance_provider.dart';
import 'package:smart_attendance_app/providers/auth_provider.dart';
import 'package:smart_attendance_app/providers/class_provider.dart';
import 'package:smart_attendance_app/providers/theme_provider.dart';

void main() {
  testWidgets('Smart Attendance App loads splash screen cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ClassProvider()),
          ChangeNotifierProvider(create: (_) => AttendanceProvider()),
          ChangeNotifierProvider(create: (_) => AIInsightProvider()),
        ],
        child: const SmartAttendanceApp(),
      ),
    );

    // Verify title text renders on Splash Screen
    expect(find.text('Smart Attendance'), findsOneWidget);
  });
}
