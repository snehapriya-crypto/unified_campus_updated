/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHostelRequestScreen extends StatefulWidget {
  const AddHostelRequestScreen({super.key});

  @override
  State<AddHostelRequestScreen> createState() => _AddHostelRequestScreenState();
}

class _AddHostelRequestScreenState extends State<AddHostelRequestScreen> {
  final nameController = TextEditingController();
  final roomController = TextEditingController();
  final problemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Hostel Request")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: "Student Name"),
            ),
            TextField(
              controller: roomController,
              decoration:
                  const InputDecoration(labelText: "Room Number"),
            ),
            TextField(
              controller: problemController,
              maxLines: 4,
              decoration:
                  const InputDecoration(labelText: "Problem Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    roomController.text.isEmpty ||
                    problemController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please fill all fields")),
                  );
                  return;
                }

                // Submit to Firestore
                await FirebaseFirestore.instance
                    .collection('hostel_requests')
                    .add({
                  'studentName': nameController.text.trim(),
                  'roomNumber': roomController.text.trim(),
                  'problemDescription': problemController.text.trim(),
                  'status': 'Pending', // default
                  'staffRemark': '',
                  'timestamp': Timestamp.now(),
                });

                // Clear fields
                nameController.clear();
                roomController.clear();
                problemController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text("Hostel request submitted ✅")),
                );

                Navigator.pop(context); // go back to previous screen
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHostelRequestScreen extends StatefulWidget {
  const AddHostelRequestScreen({super.key});

  @override
  State<AddHostelRequestScreen> createState() =>
      _AddHostelRequestScreenState();
}

class _AddHostelRequestScreenState
    extends State<AddHostelRequestScreen> {

  final nameController = TextEditingController();
  final roomController = TextEditingController();
  final problemController = TextEditingController();

  InputDecoration customDecoration(
      String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> submitHostelRequest() async {
    if (nameController.text.isEmpty ||
        roomController.text.isEmpty ||
        problemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('hostel_requests')
        .add({
      'studentName': nameController.text.trim(),
      'roomNumber': roomController.text.trim(),
      'problemDescription': problemController.text.trim(),
      'status': 'Pending',
      'staffRemark': '',
      'timestamp': Timestamp.now(),
    });

    nameController.clear();
    roomController.clear();
    problemController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Hostel request submitted successfully ✅")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Gradient AppBar
      appBar: AppBar(
        title: const Text("New Hostel Request"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // ✅ Soft background
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // Student Name
                  TextField(
                    controller: nameController,
                    decoration: customDecoration(
                        "Student Name *",
                        Icons.person),
                  ),

                  const SizedBox(height: 15),

                  // Room Number
                  TextField(
                    controller: roomController,
                    keyboardType: TextInputType.number,
                    decoration: customDecoration(
                        "Room Number *",
                        Icons.meeting_room),
                  ),

                  const SizedBox(height: 15),

                  // Problem Description
                  TextField(
                    controller: problemController,
                    maxLines: 4,
                    decoration: customDecoration(
                        "Problem Description *",
                        Icons.report_problem),
                  ),

                  const SizedBox(height: 30),

                  // ✅ Stylish Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: submitHostelRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF6A1B9A),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Submit Request",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

