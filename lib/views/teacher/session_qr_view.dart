import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/class_model.dart';
import '../../data/models/session_model.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/custom_button.dart';

class SessionQRView extends StatefulWidget {
  final ClassModel targetClass;
  final SessionModel session;

  const SessionQRView({
    super.key,
    required this.targetClass,
    required this.session,
  });

  @override
  State<SessionQRView> createState() => _SessionQRViewState();
}

class _SessionQRViewState extends State<SessionQRView> {
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.session.expiresAt.difference(DateTime.now()).inSeconds;
    if (_remainingSeconds < 0) _remainingSeconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _handleEndSession() async {
    final confirm = await ConfirmationDialog.show(
      context,
      title: 'End Live Session?',
      message: 'Ending the session will instantly deactivate the QR code. Students won\'t be able to scan further.',
      confirmText: 'End Session',
      isDanger: true,
      icon: Icons.stop_circle_rounded,
    );

    if (confirm == true && mounted) {
      await Provider.of<ClassProvider>(context, listen: false).endActiveSession();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _simulateScanAsStudent() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);

    final record = await attendanceProvider.markAttendance(
      qrPayload: widget.session.qrPayload,
      studentId: auth.currentUser?.uid ?? 'student_201',
      studentName: auth.currentUser?.name ?? 'Alex Rivera (Demo Student)',
    );

    if (mounted) {
      if (record != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Scanned! Student "${record.studentName}" attendance logged for ${widget.targetClass.subjectCode}.'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(attendanceProvider.errorMessage ?? 'Failed to log attendance.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to Dashboard',
        ),
        title: const Text('Live Attendance QR Session'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.targetClass.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.targetClass.subjectCode} • ${widget.targetClass.roomNumber}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Large Glowing QR Code Display Frame
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: widget.session.qrPayload,
                        version: QrVersions.auto,
                        size: 260.0,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: _remainingSeconds > 60
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: _remainingSeconds > 60 ? AppColors.primary : AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'QR Session Expires: $_formattedTime',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _remainingSeconds > 60 ? AppColors.primary : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Action Buttons: Share QR Token + Simulate Student Scan
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onPressed: _simulateScanAsStudent,
                      icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
                      label: const Text('Simulate Student Scan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.session.qrPayload));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied QR Session payload token to clipboard!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text('Copy / Share Token'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                CustomButton(
                  text: 'End Session & Lock QR',
                  icon: Icons.stop_circle_rounded,
                  isDanger: true,
                  onPressed: _handleEndSession,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
