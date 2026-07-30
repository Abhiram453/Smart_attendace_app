import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/attendance_record_model.dart';
import '../../providers/attendance_provider.dart';

class AttendanceHistoryView extends StatefulWidget {
  const AttendanceHistoryView({super.key});

  @override
  State<AttendanceHistoryView> createState() => _AttendanceHistoryViewState();
}

class _AttendanceHistoryViewState extends State<AttendanceHistoryView> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final allRecords = attendanceProvider.records;

    List<AttendanceRecordModel> filteredRecords = allRecords;
    if (_selectedFilter == 'present') {
      filteredRecords = allRecords.where((r) => r.status == AttendanceStatus.present).toList();
    } else if (_selectedFilter == 'absent') {
      filteredRecords = allRecords.where((r) => r.status == AttendanceStatus.absent).toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to Portal',
        ),
        title: const Text('Attendance History Log'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Chips
              Row(
                children: [
                  _buildFilterChip('all', 'All Records (${allRecords.length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip('present', 'Present'),
                  const SizedBox(width: 8),
                  _buildFilterChip('absent', 'Absent'),
                ],
              ),
              const SizedBox(height: 20),

              if (filteredRecords.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.history_rounded, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No history records matching filter', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredRecords.length,
                  itemBuilder: (context, index) {
                    final record = filteredRecords[index];
                    final formattedDate = DateFormat('EEE, MMM dd, yyyy • hh:mm a').format(record.timestamp);
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
                        title: Text(record.className, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}
