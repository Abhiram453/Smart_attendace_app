import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AttendanceChartWidget extends StatelessWidget {
  final int presentCount;
  final int absentCount;
  final int lateCount;

  const AttendanceChartWidget({
    super.key,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = presentCount + absentCount + lateCount;

    if (total == 0) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const Text('No attendance records available for chart analytics.'),
      );
    }

    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Class Attendance Distribution',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 35,
                          sections: [
                            PieChartSectionData(
                              color: AppColors.success,
                              value: presentCount.toDouble(),
                              title: '${((presentCount / total) * 100).toStringAsFixed(0)}%',
                              radius: 38,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              color: AppColors.error,
                              value: absentCount.toDouble(),
                              title: '${((absentCount / total) * 100).toStringAsFixed(0)}%',
                              radius: 38,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (lateCount > 0)
                              PieChartSectionData(
                                color: AppColors.warning,
                                value: lateCount.toDouble(),
                                title: '${((lateCount / total) * 100).toStringAsFixed(0)}%',
                                radius: 38,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegend(color: AppColors.success, label: 'Present ($presentCount)'),
                          const SizedBox(height: 8),
                          _buildLegend(color: AppColors.error, label: 'Absent ($absentCount)'),
                          if (lateCount > 0) ...[
                            const SizedBox(height: 8),
                            _buildLegend(color: AppColors.warning, label: 'Late ($lateCount)'),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
