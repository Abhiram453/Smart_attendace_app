import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/ai_insight_model.dart';

class AIInsightCard extends StatelessWidget {
  final AIInsightModel insight;
  final VoidCallback? onActionPressed;

  const AIInsightCard({
    super.key,
    required this.insight,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color cardBorderColor;
    Color iconColor;
    IconData icon;

    switch (insight.type) {
      case AIInsightType.lowAttendanceWarning:
        cardBorderColor = AppColors.error;
        iconColor = AppColors.error;
        icon = Icons.warning_amber_rounded;
        break;
      case AIInsightType.streakReward:
        cardBorderColor = AppColors.success;
        iconColor = AppColors.success;
        icon = Icons.stars_rounded;
        break;
      case AIInsightType.teacherRecommendation:
        cardBorderColor = AppColors.warning;
        iconColor = AppColors.warning;
        icon = Icons.insights_rounded;
        break;
      case AIInsightType.info:
        cardBorderColor = AppColors.primary;
        iconColor = AppColors.primaryLight;
        icon = Icons.auto_awesome;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.stitchCardDark : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorderColor.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: cardBorderColor.withValues(alpha: 0.1),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    insight.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    insight.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: onActionPressed,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              insight.actionText,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: iconColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 14, color: iconColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
