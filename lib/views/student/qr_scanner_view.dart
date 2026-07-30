import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/app_illustration.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/custom_button.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  final _manualTokenController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _manualTokenController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _processScannedToken(barcode.rawValue!);
        break;
      }
    }
  }

  void _processScannedToken(String token) async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    final confirm = await ConfirmationDialog.show(
      context,
      title: 'Confirm Attendance Submission',
      message: 'Log your attendance for current active session with token:\n"$token"?',
      confirmText: 'Submit Attendance',
      icon: Icons.qr_code_scanner_rounded,
      iconColor: AppColors.secondary,
    );

    if (confirm == true && mounted) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);

      final record = await attendanceProvider.markAttendance(
        qrPayload: token,
        studentId: auth.currentUser?.uid ?? 'student_201',
        studentName: auth.currentUser?.name ?? 'Alex Rivera',
      );

      if (mounted) {
        if (record != null) {
          _showSuccessModal(record.className);
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

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showSuccessModal(String className) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppIllustration(type: IllustrationType.successCheck, size: 100),
            const SizedBox(height: 16),
            const Text(
              'Attendance Marked! 🎉',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your attendance for "$className" has been logged in Firestore.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close modal
                Navigator.pop(context); // Return to Dashboard
              },
              child: const Text('Return to Portal'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool isCameraSupported = kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to Student Portal',
        ),
        title: const Text('Scan QR Code'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Scanner View Frame
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : Colors.black,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.secondary, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: isCameraSupported
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            MobileScanner(
                              controller: _scannerController,
                              onDetect: _onDetect,
                            ),
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.secondary, width: 3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            if (_isProcessing)
                              Container(
                                color: Colors.black54,
                                child: const Center(
                                  child: CircularProgressIndicator(color: AppColors.secondary),
                                ),
                              ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppIllustration(type: IllustrationType.qrScan, size: 90),
                            const SizedBox(height: 16),
                            const Text(
                              'Desktop QR Entry Mode',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 6),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'Camera scanning operates on Mobile & Web. On Desktop, paste the QR token below.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Manual Code Input Fallback Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.keyboard_outlined, color: AppColors.secondary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Manual Token Entry (Web & Desktop Fallback)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _manualTokenController,
                      decoration: const InputDecoration(
                        hintText: 'Paste or type QR session token payload...',
                        prefixIcon: Icon(Icons.token_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    CustomButton(
                      text: 'Submit Token',
                      icon: Icons.send_rounded,
                      width: double.infinity,
                      onPressed: () {
                        final text = _manualTokenController.text.trim();
                        if (text.isNotEmpty) {
                          _processScannedToken(text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter or paste a valid session token')),
                          );
                        }
                      },
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
}
