import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/custom_button.dart';

class CreateClassView extends StatefulWidget {
  const CreateClassView({super.key});

  @override
  State<CreateClassView> createState() => _CreateClassViewState();
}

class _CreateClassViewState extends State<CreateClassView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectCodeController = TextEditingController();
  final _roomController = TextEditingController();
  final _enrolledController = TextEditingController(text: '45');

  @override
  void dispose() {
    _titleController.dispose();
    _subjectCodeController.dispose();
    _roomController.dispose();
    _enrolledController.dispose();
    super.dispose();
  }

  void _handleCreate() async {
    if (_formKey.currentState!.validate()) {
      final confirm = await ConfirmationDialog.show(
        context,
        title: 'Confirm Class Creation',
        message: 'Create class "${_titleController.text.trim()}" (${_subjectCodeController.text.trim()})?',
        confirmText: 'Create Class',
      );

      if (confirm == true && mounted) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        final classProvider = Provider.of<ClassProvider>(context, listen: false);

        final success = await classProvider.createClass(
          title: _titleController.text.trim(),
          subjectCode: _subjectCodeController.text.trim(),
          roomNumber: _roomController.text.trim(),
          teacherId: auth.currentUser?.uid ?? 'teacher_101',
          teacherName: auth.currentUser?.name ?? 'Dr. Sarah Jenkins',
          totalEnrolledStudents: int.tryParse(_enrolledController.text.trim()) ?? 30,
        );

        if (success && mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back to Workspace',
        ),
        title: const Text('Create New Class'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.add_box_rounded, color: AppColors.primary, size: 28),
                        SizedBox(width: 10),
                        Text(
                          'Course Setup Details',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Course Title (e.g. Mobile App Dev)',
                        prefixIcon: Icon(Icons.book_outlined),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subjectCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Subject Code (e.g. CS401)',
                        prefixIcon: Icon(Icons.numbers_outlined),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter subject code' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _roomController,
                      decoration: const InputDecoration(
                        labelText: 'Room Number / Lab (e.g. Lab 304)',
                        prefixIcon: Icon(Icons.room_outlined),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter room location' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _enrolledController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Expected Student Count',
                        prefixIcon: Icon(Icons.people_outline),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter student count' : null,
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      text: 'Save & Create Class',
                      icon: Icons.check_circle_rounded,
                      isLoading: classProvider.isLoading,
                      onPressed: _handleCreate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
