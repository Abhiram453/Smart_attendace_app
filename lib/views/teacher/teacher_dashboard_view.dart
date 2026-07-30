import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_layout.dart';
import '../../data/models/class_model.dart';
import '../../data/models/session_model.dart';
import '../../providers/ai_insight_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/role_selection_view.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/stat_card.dart';
import 'class_analytics_view.dart';
import 'class_details_view.dart';
import 'create_class_view.dart';
import 'session_qr_view.dart';

class TeacherDashboardView extends StatefulWidget {
  const TeacherDashboardView({super.key});

  @override
  State<TeacherDashboardView> createState() => _TeacherDashboardViewState();
}

class _TeacherDashboardViewState extends State<TeacherDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.currentUser != null) {
        Provider.of<ClassProvider>(context, listen: false).fetchTeacherClasses(auth.currentUser!.uid);
        Provider.of<AIInsightProvider>(context, listen: false).evaluateTeacherClass(
          className: 'Advanced Mobile App Dev (CS401)',
          attendancePercentage: 88.5,
          totalStudents: 42,
          absentCount: 5,
        );
      }
    });
  }

  void _handleLogout() async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Confirm Logout',
      message: 'Are you sure you want to sign out of your Teacher Workspace?',
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
    final classProvider = Provider.of<ClassProvider>(context);
    final aiProvider = Provider.of<AIInsightProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final teacherName = authProvider.currentUser?.name ?? 'Dr. Sarah Jenkins';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Workspace'),
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
            MaterialPageRoute(builder: (_) => const CreateClassView()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Create Class', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (authProvider.currentUser != null) {
              await classProvider.fetchTeacherClasses(authProvider.currentUser!.uid);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Welcome Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
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
                        child: Icon(Icons.school_rounded, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $teacherName 👋',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Manage your courses, active sessions & AI attendance analytics',
                              style: TextStyle(fontSize: 13, color: Colors.white70),
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
                        title: 'Total Active Classes',
                        value: '${classProvider.classes.length}',
                        icon: Icons.class_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 12),
                      StatCard(
                        title: 'Avg. Attendance Rate',
                        value: '88.5%',
                        icon: Icons.trending_up_rounded,
                        color: AppColors.success,
                        subtitle: '+3.2% from last week',
                      ),
                    ],
                  ),
                  desktop: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Total Active Classes',
                          value: '${classProvider.classes.length}',
                          icon: Icons.class_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: 'Avg. Attendance Rate',
                          value: '88.5%',
                          icon: Icons.trending_up_rounded,
                          color: AppColors.success,
                          subtitle: '+3.2% from last week',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // AI Insights Section
                const Row(
                  children: [
                    Icon(Icons.psychology_rounded, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Rule-Based AI Class Recommendations',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (aiProvider.teacherInsights.isEmpty)
                  const Text('AI rule engine analyzing class engagement...')
                else
                  ...aiProvider.teacherInsights.map(
                    (insight) => AIInsightCard(
                      insight: insight,
                      onActionPressed: () {
                        if (classProvider.classes.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClassAnalyticsView(targetClass: classProvider.classes.first),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                const SizedBox(height: 24),

                // Classes Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Classes',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${classProvider.classes.length} Courses',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (classProvider.isLoading)
                  const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                else if (classProvider.classes.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.add_location_alt_outlined, size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No classes created yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('Tap "+ Create Class" below to get started', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: classProvider.classes.length,
                    itemBuilder: (context, index) {
                      final cls = classProvider.classes[index];
                      return _buildClassCard(context, cls);
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

  Widget _buildClassCard(BuildContext context, ClassModel cls) {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    cls.subjectCode,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  cls.roomNumber,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                  onPressed: () async {
                    final confirm = await ConfirmationDialog.show(
                      context,
                      title: 'Delete Class?',
                      message: 'Are you sure you want to delete "${cls.title}"? All attendance history for this class will be removed.',
                      confirmText: 'Delete',
                      isDanger: true,
                    );
                    if (confirm == true) {
                      classProvider.deleteClass(cls.id);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              cls.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.people_outline_rounded, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '${cls.totalEnrolledStudents} Enrolled Students',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 20),
                    label: const Text('Start QR Session', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      SessionModel? session = await classProvider.generateQRSession(cls.id);
                      session ??= SessionModel(
                        sessionId: 'ses_${DateTime.now().millisecondsSinceEpoch}',
                        classId: cls.id,
                        qrPayload: 'SMART_ATTENDANCE_${cls.id}_${DateTime.now().millisecondsSinceEpoch}',
                        createdAt: DateTime.now(),
                        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
                        isActive: true,
                      );
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SessionQRView(targetClass: cls, session: session!),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.18),
                  ),
                  icon: const Icon(Icons.bar_chart_rounded, color: AppColors.primaryLight),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClassAnalyticsView(targetClass: cls),
                      ),
                    );
                  },
                  tooltip: 'View Analytics',
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.18),
                  ),
                  icon: const Icon(Icons.list_alt_rounded, color: AppColors.secondary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClassDetailsView(targetClass: cls),
                      ),
                    );
                  },
                  tooltip: 'Class Records',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
