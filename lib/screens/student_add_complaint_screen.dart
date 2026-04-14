/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAddComplaintScreen extends StatefulWidget {
  const StudentAddComplaintScreen({super.key});

  @override
  State<StudentAddComplaintScreen> createState() =>
      _StudentAddComplaintScreenState();
}

class _StudentAddComplaintScreenState extends State<StudentAddComplaintScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  Future<void> submitComplaint() async {
    if (_nameController.text.isEmpty ||
        _rollController.text.isEmpty ||
        _complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('complaints').add({
        'name': _nameController.text.trim(),
        'rollNo': _rollController.text.trim(),
        'year': _yearController.text.trim(),
        'department': _deptController.text.trim(),
        'section': _sectionController.text.trim(),
        'complaint': _complaintController.text.trim(),
        'status': 'Pending', // ✅ add default status
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint submitted successfully ✅")),
      );

      _nameController.clear();
      _rollController.clear();
      _yearController.clear();
      _deptController.clear();
      _sectionController.clear();
      _complaintController.clear();

      Navigator.pop(context); // ✅ return to list screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting complaint: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Complaint"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _rollController,
              decoration: const InputDecoration(
                labelText: "Roll No *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: "Year",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _deptController,
              decoration: const InputDecoration(
                labelText: "Department",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sectionController,
              decoration: const InputDecoration(
                labelText: "Section",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _complaintController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Complaint *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitComplaint,
                child: const Text("Submit Complaint"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentAddComplaintScreen extends StatefulWidget {
  const StudentAddComplaintScreen({super.key});

  @override
  State<StudentAddComplaintScreen> createState() =>
      _StudentAddComplaintScreenState();
}

class _StudentAddComplaintScreenState
    extends State<StudentAddComplaintScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  bool isLoading = false;

  Future<void> submitComplaint() async {
    if (_nameController.text.isEmpty ||
        _rollController.text.isEmpty ||
        _complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('complaints').add({
        'name': _nameController.text.trim(),
        'rollNo': _rollController.text.trim(),
        'year': _yearController.text.trim(),
        'department': _deptController.text.trim(),
        'section': _sectionController.text.trim(),
        'complaint': _complaintController.text.trim(),
        'status': 'Pending',
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint submitted successfully ✅")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  InputDecoration customInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Complaint",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            /// Name
            TextField(
              controller: _nameController,
              decoration: customInput("Name *", Icons.person),
            ),
            const SizedBox(height: 15),

            /// Roll No
            TextField(
              controller: _rollController,
              decoration: customInput("Roll No *", Icons.badge),
            ),
            const SizedBox(height: 15),

            /// Year
            TextField(
              controller: _yearController,
              decoration: customInput("Year", Icons.calendar_today),
            ),
            const SizedBox(height: 15),

            /// Department
            TextField(
              controller: _deptController,
              decoration: customInput("Department", Icons.school),
            ),
            const SizedBox(height: 15),

            /// Section
            TextField(
              controller: _sectionController,
              decoration: customInput("Section", Icons.group),
            ),
            const SizedBox(height: 15),

            /// Complaint
            TextField(
              controller: _complaintController,
              maxLines: 4,
              decoration:
                  customInput("Write your Complaint *", Icons.report),
            ),

            const SizedBox(height: 30),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "SUBMIT COMPLAINT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentAddComplaintScreen extends StatefulWidget {
  const StudentAddComplaintScreen({super.key});

  @override
  State<StudentAddComplaintScreen> createState() =>
      _StudentAddComplaintScreenState();
}

class _StudentAddComplaintScreenState
    extends State<StudentAddComplaintScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  bool isLoading = false;

  // FUNCTION TO GET PRIORITY FROM ML API
  Future<String> getPriority(String complaintText) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:5000/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "complaint": complaintText,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["priority"];
      } else {
        return "Medium";
      }
    } catch (e) {
      return "Medium";
    }
  }

  Future<void> submitComplaint() async {
    if (_nameController.text.isEmpty ||
        _rollController.text.isEmpty ||
        _complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      String complaintText = _complaintController.text.trim();

      // GET PRIORITY FROM ML MODEL
      String priority = await getPriority(complaintText);

      // SAVE TO FIRESTORE
      await FirebaseFirestore.instance.collection('complaints').add({
        'name': _nameController.text.trim(),
        'rollNo': _rollController.text.trim(),
        'year': _yearController.text.trim(),
        'department': _deptController.text.trim(),
        'section': _sectionController.text.trim(),
        'complaint': complaintText,
        'priority': priority,
        'status': 'Pending',
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint submitted successfully ✅")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  InputDecoration customInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Complaint",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [

            TextField(
              controller: _nameController,
              decoration: customInput("Name *", Icons.person),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _rollController,
              decoration: customInput("Roll No *", Icons.badge),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _yearController,
              decoration: customInput("Year", Icons.calendar_today),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _deptController,
              decoration: customInput("Department", Icons.school),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _sectionController,
              decoration: customInput("Section", Icons.group),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _complaintController,
              maxLines: 4,
              decoration:
                  customInput("Write your Complaint *", Icons.report),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "SUBMIT COMPLAINT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
