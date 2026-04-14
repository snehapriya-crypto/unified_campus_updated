import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class AdminPostNoticePage extends StatefulWidget {
  const AdminPostNoticePage({super.key});

  @override
  State<AdminPostNoticePage> createState() => _AdminPostNoticePageState();
}

class _AdminPostNoticePageState extends State<AdminPostNoticePage> {
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // Department
  String _selectedDept = 'IT';
  final List<String> _departments = [
    'IT',
    'CSE',
    'ECE',
    'EEE',
    'IoT',
    'AIDS',
    'Cybersecurity',
    'All',
  ];

  // Year checklist
  List<String> _years = ['1', '2', '3', '4'];
  List<String> _selectedYears = [];
  bool _allYearsSelected = false;

  // File picker
  PlatformFile? _pickedFile;
  String? _fileName;

  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Notice'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Enter Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Enter Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // File Picker
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: Text(_fileName ?? 'Upload Image / PDF'),
            ),
            const SizedBox(height: 16),

            // Department Dropdown
            DropdownButtonFormField<String>(
              value: _selectedDept,
              items: _departments
                  .map((dept) => DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDept = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Select Department',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Year Checklist
            const Text(
              'Select Years',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ..._years.map((year) {
                  return FilterChip(
                    label: Text('Year $year'),
                    selected: _selectedYears.contains(year),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedYears.add(year);
                          _allYearsSelected = false;
                        } else {
                          _selectedYears.remove(year);
                        }
                      });
                    },
                  );
                }).toList(),
                FilterChip(
                  label: const Text('All Years'),
                  selected: _allYearsSelected,
                  onSelected: (selected) {
                    setState(() {
                      _allYearsSelected = selected;
                      if (selected) _selectedYears.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Post Notice Button
            Center(
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadNotice,
                      child: const Text('POST NOTICE'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Pick file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.first;
        _fileName = _pickedFile!.name;
      });
    }
  }

  // Upload notice
  Future<void> _uploadNotice() async {
    String title = _titleController.text.trim();
    String desc = _descController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and description')),
      );
      return;
    }

    if (!_allYearsSelected && _selectedYears.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one year')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String? fileUrl;
    String fileType = 'none';

    try {
      // Upload file if selected
      if (_pickedFile != null) {
        String fileName = path.basename(_pickedFile!.name);
        Reference ref =
            FirebaseStorage.instance.ref().child('notices/$fileName');

        UploadTask uploadTask;
        if (kIsWeb) {
          if (_pickedFile!.bytes != null) {
            uploadTask = ref.putData(_pickedFile!.bytes!);
          } else {
            throw Exception('File bytes are null');
          }
        } else {
          if (_pickedFile!.path != null) {
            uploadTask = ref.putFile(File(_pickedFile!.path!));
          } else {
            throw Exception('File path is null');
          }
        }

        TaskSnapshot snapshot = await uploadTask;
        fileUrl = await snapshot.ref.getDownloadURL();

        // Detect file type
        if (_pickedFile!.extension == 'pdf') {
          fileType = 'pdf';
        } else {
          fileType = 'image';
        }
      }

      // Get admin info
      final user = FirebaseAuth.instance.currentUser;
      String postedByEmail = user?.email ?? 'admin@test.com';
      String postedByRole = 'admin';

      // Save notice in Firestore
      await FirebaseFirestore.instance.collection('notices').add({
        'title': title,
        'description': desc,
        'fileUrl': fileUrl ?? '',
        'fileType': fileType,
        'department': _selectedDept,
        'years': _allYearsSelected ? ['All'] : _selectedYears,
        'postedByRole': postedByRole,
        'postedByEmail': postedByEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notice posted successfully')),
      );

      // Clear fields
      _titleController.clear();
      _descController.clear();
      setState(() {
        _pickedFile = null;
        _fileName = null;
        _selectedDept = 'IT';
        _selectedYears.clear();
        _allYearsSelected = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }
}
