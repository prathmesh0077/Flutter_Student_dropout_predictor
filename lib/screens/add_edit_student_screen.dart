import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

// To access the _changeLanguage method
import '../models/student_model.dart';
import '../utils/app_localizations.dart';

// The rest of the file (class DashboardScreen extends...) starts here



class AddEditStudentScreen extends StatefulWidget {
  // If a student object is passed, the screen is in 'Edit' mode.
  // If it's null, the screen is in 'Add' mode.
  final Student? student;

  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _attendanceController;
  late TextEditingController _marksController;
  late TextEditingController _phoneController;
  late bool _feesPaid;

  bool get _isEditMode => widget.student != null;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with the student's data if in edit mode,
    // otherwise initialize with empty/default values.
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _attendanceController = TextEditingController(text: widget.student?.attendance.toString() ?? '');
    _marksController = TextEditingController(text: widget.student?.marks.toString() ?? '');
    _phoneController = TextEditingController(text: widget.student?.guardianPhone ?? '');
    _feesPaid = widget.student?.feesPaid ?? false;
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree.
    _nameController.dispose();
    _attendanceController.dispose();
    _marksController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    // First, validate the form. If it's not valid, do nothing.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final studentsBox = Hive.box<Student>('students');

    if (_isEditMode) {
      // --- UPDATE EXISTING STUDENT ---
      widget.student!.name = _nameController.text;
      widget.student!.attendance = double.parse(_attendanceController.text);
      widget.student!.marks = double.parse(_marksController.text);
      widget.student!.guardianPhone = _phoneController.text;
      widget.student!.feesPaid = _feesPaid;
      widget.student!.lastUpdated = DateTime.now();
      
      // Hive objects have a save() method to persist changes.
      await widget.student!.save();
    } else {
      // --- ADD NEW STUDENT ---
      final newStudent = Student(
        name: _nameController.text,
        attendance: double.parse(_attendanceController.text),
        marks: double.parse(_marksController.text),
        guardianPhone: _phoneController.text,
        feesPaid: _feesPaid,
        lastUpdated: DateTime.now(),
        weeklySnapshots: [],
      );
      // The add() method adds a new object to the box.
      await studentsBox.add(newStudent);
    }

    // Go back to the dashboard screen after saving.
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteStudent() async {
    final localizations = AppLocalizations.of(context);
    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.text('confirmDeleteTitle')),
        content: Text(localizations.text('confirmDeleteContent')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(localizations.text('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(localizations.text('delete'), style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && _isEditMode) {
      // The delete() method on a Hive object removes it from the box.
      await widget.student!.delete();
      if(mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? localizations.text('editStudent') : localizations.text('addStudent')),
        actions: [
          // Only show the delete button if we are in edit mode.
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteStudent,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- FORM FIELDS ---
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: localizations.text('studentName')),
                validator: (value) => value == null || value.isEmpty ? localizations.text('nameRequired') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: localizations.text('guardianPhone')),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                validator: (value) {
                  if (value == null || value.isEmpty) return localizations.text('phoneRequired');
                  if (value.length != 10) return localizations.text('phoneInvalid');
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _attendanceController,
                decoration: InputDecoration(labelText: localizations.text('attendance')),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                 validator: (value) => value == null || value.isEmpty ? localizations.text('attendanceRequired') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _marksController,
                decoration: InputDecoration(labelText: localizations.text('marks')),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                 validator: (value) => value == null || value.isEmpty ? localizations.text('marksRequired') : null,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(localizations.text('feesPaid')),
                value: _feesPaid,
                onChanged: (bool value) {
                  setState(() {
                    _feesPaid = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveStudent,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(localizations.text('save')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

