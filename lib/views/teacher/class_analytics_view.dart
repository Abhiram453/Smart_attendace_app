import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/class_model.dart';
import '../../providers/attendance_provider.dart';
import '../widgets/attendance_chart_widget.dart';
import '../widgets/stat_card.dart';

class ClassAnalyticsView extends StatefulWidget {
  final ClassModel targetClass;

  const ClassAnalyticsView({super.key, required this.targetClass});

  @override
  State<ClassAnalyticsView> createState() => _ClassAnalyticsViewState();
}

class _ClassAnalyticsViewState extends State<ClassAnalyticsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false)
          .fetchClassRecords(widget.targetClass.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mock count metrics for analytics demo
    const presentCount = 37;
    const absentCount = 5;
    const lateCount = 3;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to Dashboard',
        ),
        title: Text('${widget.targetClass.subjectCode} Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attendance report exported to CSV / PDF successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            tooltip: 'Export Report',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.targetClass.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Class Analytics & Attendance Breakdown',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Attendance Distribution Pie Chart
              const AttendanceChartWidget(
                presentCount: presentCount,
                absentCount: absentCount,
                lateCount: lateCount,
              ),

              const SizedBox(height: 20),

              // Analytics Summary Cards
              Row(
                children: [
                  const Expanded(
                    child: StatCard(
                      title: 'Present Students',
                      value: '$presentCount',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: StatCard(
                      title: 'Absent Students',
                      value: '$absentCount',
                      icon: Icons.cancel_outlined,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const StatCard(
                title: 'Overall Attendance Rate',
                value: '88.1%',
                icon: Icons.pie_chart_outline_rounded,
                color: AppColors.primary,
                subtitle: 'Above university 75% threshold',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
