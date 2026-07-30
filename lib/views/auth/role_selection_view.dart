import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_layout.dart';
import '../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/theme_provider.dart';
import '../student/student_dashboard_view.dart';
import '../teacher/teacher_dashboard_view.dart';
import '../widgets/app_illustration.dart';
import 'login_view.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Attendance AI'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Light/Dark Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(context),
          desktop: _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Google Stitch Aura Title Header
          ShaderMask(
            shaderCallback: (bounds) => AppColors.aiGlowGradient.createShader(bounds),
            child: const Text(
              'Smart Attendance AI',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Powered by Google Stitch AI Design System',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildStitchRoleCard(
            context,
            role: UserRole.teacher,
            title: 'Teacher Workspace',
            subtitle: 'Create classes, generate dynamic QR codes & view AI class insights',
            illustration: IllustrationType.roleTeacher,
            gradient: AppColors.stitchGradient,
          ),
          const SizedBox(height: 20),
          _buildStitchRoleCard(
            context,
            role: UserRole.student,
            title: 'Student Portal',
            subtitle: 'Scan session QR codes, track attendance & receive AI risk alerts',
            illustration: IllustrationType.roleStudent,
            gradient: AppColors.successGradient,
          ),
          const SizedBox(height: 24),
          _buildQuickDemoSection(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _handleQuickDemo(BuildContext context, UserRole role) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final classProvider = Provider.of<ClassProvider>(context, listen: false);

    if (role == UserRole.teacher) {
      await authProvider.signIn(email: 'sarah@university.edu', password: 'password123');
      if (context.mounted) {
        classProvider.fetchTeacherClasses(authProvider.currentUser!.uid);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherDashboardView()));
      }
    } else {
      await authProvider.signIn(email: 'alex@student.edu', password: 'password123');
      if (context.mounted) {
        classProvider.fetchStudentClasses(authProvider.currentUser!.uid);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentDashboardView()));
      }
    }
  }

  Widget _buildQuickDemoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 6),
              Text(
                'Instant Demo Mode (Quick Explore)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                ),
                onPressed: () => _handleQuickDemo(context, UserRole.teacher),
                icon: const Icon(Icons.school_rounded, size: 18),
                label: const Text('Try Teacher Demo'),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
                ),
                onPressed: () => _handleQuickDemo(context, UserRole.student),
                icon: const Icon(Icons.person_rounded, size: 18),
                label: const Text('Try Student Demo'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 920),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.aiGlowGradient.createShader(bounds),
              child: const Text(
                'Smart Attendance AI Platform',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Select your workspace role to initialize your session',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 36),
            Row(
              children: [
                Expanded(
                  child: _buildStitchRoleCard(
                    context,
                    role: UserRole.teacher,
                    title: 'Teacher Workspace',
                    subtitle: 'Create classes, generate dynamic QR codes & view AI class insights',
                    illustration: IllustrationType.roleTeacher,
                    gradient: AppColors.stitchGradient,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildStitchRoleCard(
                    context,
                    role: UserRole.student,
                    title: 'Student Portal',
                    subtitle: 'Scan session QR codes, track attendance & receive AI risk alerts',
                    illustration: IllustrationType.roleStudent,
                    gradient: AppColors.successGradient,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildQuickDemoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStitchRoleCard(
    BuildContext context, {
    required UserRole role,
    required String title,
    required String subtitle,
    required IllustrationType illustration,
    required LinearGradient gradient,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.stitchSurfaceDark : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? AppColors.stitchBorderDark : Colors.black.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginView(selectedRole: role)),
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                AppIllustration(type: illustration, size: 120),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Launch Workspace ',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
