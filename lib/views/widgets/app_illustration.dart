import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum IllustrationType {
  roleTeacher,
  roleStudent,
  qrGenerate,
  qrScan,
  aiRobot,
  successCheck,
  emptyBox
}

class AppIllustration extends StatelessWidget {
  final IllustrationType type;
  final double size;

  const AppIllustration({
    super.key,
    required this.type,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case IllustrationType.roleTeacher:
        return _buildGraphicContainer(
          icon: Icons.school_rounded,
          gradient: AppColors.primaryGradient,
          badgeIcon: Icons.menu_book_rounded,
        );
      case IllustrationType.roleStudent:
        return _buildGraphicContainer(
          icon: Icons.person_search_rounded,
          gradient: AppColors.accentGradient,
          badgeIcon: Icons.qr_code_scanner_rounded,
        );
      case IllustrationType.qrGenerate:
        return _buildGraphicContainer(
          icon: Icons.qr_code_2_rounded,
          gradient: AppColors.primaryGradient,
          badgeIcon: Icons.auto_awesome,
        );
      case IllustrationType.qrScan:
        return _buildGraphicContainer(
          icon: Icons.center_focus_strong_rounded,
          gradient: AppColors.successGradient,
          badgeIcon: Icons.verified_user_rounded,
        );
      case IllustrationType.aiRobot:
        return _buildGraphicContainer(
          icon: Icons.psychology_rounded,
          gradient: AppColors.warningGradient,
          badgeIcon: Icons.bolt_rounded,
        );
      case IllustrationType.successCheck:
        return _buildGraphicContainer(
          icon: Icons.check_circle_rounded,
          gradient: AppColors.successGradient,
          badgeIcon: Icons.star_rounded,
        );
      case IllustrationType.emptyBox:
        return _buildGraphicContainer(
          icon: Icons.inbox_rounded,
          gradient: const LinearGradient(colors: [Colors.grey, Colors.blueGrey]),
          badgeIcon: Icons.search_rounded,
        );
    }
  }

  Widget _buildGraphicContainer({
    required IconData icon,
    required LinearGradient gradient,
    required IconData badgeIcon,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.85,
            height: size * 0.85,
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(icon, size: size * 0.45, color: Colors.white),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(size * 0.08),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(badgeIcon, size: size * 0.22, color: gradient.colors.first),
            ),
          ),
        ],
      ),
    );
  }
}
