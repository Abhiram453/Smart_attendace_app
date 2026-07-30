import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_layout.dart';
import '../../providers/ai_insight_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/role_selection_view.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/stat_card.dart';
import 'attendance_history_view.dart';
import 'qr_scanner_view.dart';

class StudentDashboardView extends StatefulWidget {
  const StudentDashboardView({super.key});

  @override
  State<StudentDashboardView> createState() => _StudentDashboardViewState();
}

class _StudentDashboardViewState extends State<StudentDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.currentUser != null) {
        final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
        await attendanceProvider.fetchStudentRecords(auth.currentUser!.uid);
        if (!mounted) return;
        Provider.of<ClassProvider>(context, listen: false).fetchStudentClasses(auth.currentUser!.uid);
        
        Provider.of<AIInsightProvider>(context, listen: false).evaluateStudent(
          attendanceProvider.records,
          totalSessions: 5,
        );
      }
    });
  }

  void _handleLogout() async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Confirm Logout',
      message: 'Are you sure you want to sign out of your Student Portal?',
      confirmText: 'Sign Out',
      isDanger: true,
      icon: Icons.logout_rounded,
    );

    if (confirmed == true && mounted) {
      await Provider.of<AuthProvider>(context, listen: false).logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);
    final aiProvider = Provider.of<AIInsightProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final studentName = authProvider.currentUser?.name ?? 'Alex Rivera';
    final overallPct = attendanceProvider.overallAttendancePercentage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Portal'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QRScannerView()),
          );
        },
        backgroundColor: AppColors.secondary,
        icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
        label: const Text('Scan QR Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (authProvider.currentUser != null) {
              await attendanceProvider.fetchStudentRecords(authProvider.currentUser!.uid);
              aiProvider.evaluateStudent(attendanceProvider.records);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Student Welcome Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person_rounded, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, $studentName 🎓',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${authProvider.currentUser?.studentId ?? 'STU-89210'}',
                              style: const TextStyle(fontSize: 13, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Stat Summary Grid
                ResponsiveLayout(
                  mobile: Column(
                    children: [
                      StatCard(
                        title: 'Overall Attendance Rate',
                        value: '${overallPct.toStringAsFixed(1)}%',
                        icon: Icons.check_circle_outline_rounded,
                        color: overallPct >= 75 ? AppColors.success : AppColors.error,
                        subtitle: overallPct >= 75 ? 'Optimal Standing' : 'Low Attendance Warning',
                      ),
                      const SizedBox(height: 12),
                      StatCard(
                        title: 'Active Courses',
                        value: '${classProvider.classes.length}',
                        icon: Icons.auto_stories_rounded,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  desktop: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Overall Attendance Rate',
                          value: '${overallPct.toStringAsFixed(1)}%',
                          icon: Icons.check_circle_outline_rounded,
                          color: overallPct >= 75 ? AppColors.success : AppColors.error,
                          subtitle: overallPct >= 75 ? 'Optimal Standing' : 'Low Attendance Warning',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: 'Active Courses',
                          value: '${classProvider.classes.length}',
                          icon: Icons.auto_stories_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Rule-Based AI Risk & Reward Notifications
                const Row(
                  children: [
                    Icon(Icons.psychology_rounded, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Smart Alerts & Insights',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (aiProvider.studentInsights.isEmpty)
                  const Text('No AI risk alerts. Attendance is in good standing!')
                else
                  ...aiProvider.studentInsights.map(
                    (insight) => AIInsightCard(
                      insight: insight,
                      onActionPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AttendanceHistoryView()),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 24),

                // Quick Navigation Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Registered Courses',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AttendanceHistoryView()),
                        );
                      },
                      icon: const Icon(Icons.history_rounded, size: 18),
                      label: const Text('View History'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (classProvider.classes.isEmpty)
                  const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: classProvider.classes.length,
                    itemBuilder: (context, index) {
                      final cls = classProvider.classes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primaryLight,
                            child: Icon(Icons.menu_book_rounded, color: Colors.white),
                          ),
                          title: Text(cls.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${cls.subjectCode} • ${cls.teacherName}'),
                          trailing: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.secondary.withValues(alpha: 0.18),
                            ),
                            icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.secondary),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const QRScannerView()),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
