import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/attendance_record_model.dart';
import '../../data/models/class_model.dart';
import '../../providers/attendance_provider.dart';

class ClassDetailsView extends StatefulWidget {
  final ClassModel targetClass;

  const ClassDetailsView({super.key, required this.targetClass});

  @override
  State<ClassDetailsView> createState() => _ClassDetailsViewState();
}

class _ClassDetailsViewState extends State<ClassDetailsView> {
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
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to Dashboard',
        ),
        title: Text('${widget.targetClass.subjectCode} Student Log'),
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
                'Student Roster & Recent QR Log Entries',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 20),

              if (attendanceProvider.records.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.history_toggle_off_rounded, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No scanned logs yet for this class', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Logs will automatically populate when students scan the session QR.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceProvider.records.length,
                  itemBuilder: (context, index) {
                    final record = attendanceProvider.records[index];
                    return _buildRecordTile(record);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordTile(AttendanceRecordModel record) {
    final formattedTime = DateFormat('MMM dd, yyyy • hh:mm a').format(record.timestamp);
    final isPresent = record.status == AttendanceStatus.present;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPresent ? AppColors.success.withValues(alpha: 0.15) : AppColors.error.withValues(alpha: 0.15),
          child: Icon(
            isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isPresent ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(record.studentName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(formattedTime, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isPresent ? AppColors.success.withValues(alpha: 0.15) : AppColors.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            record.status.name.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isPresent ? AppColors.success : AppColors.error,
            ),
          ),
        ),
      ),
    );
  }
}
