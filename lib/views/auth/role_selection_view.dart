import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_layout.dart';
import '../../data/models/user_model.dart';
import '../../providers/theme_provider.dart';
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
          const SizedBox(height: 30),
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
            const SizedBox(height: 48),
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
