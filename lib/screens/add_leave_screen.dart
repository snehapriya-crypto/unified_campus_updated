/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddLeaveScreen extends StatefulWidget {
  const AddLeaveScreen({super.key});

  @override
  State<AddLeaveScreen> createState() => _AddLeaveScreenState();
}

class _AddLeaveScreenState extends State<AddLeaveScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  Future<void> submitLeaveRequest() async {
    if (nameController.text.isEmpty ||
        rollController.text.isEmpty ||
        fromDateController.text.isEmpty ||
        toDateController.text.isEmpty ||
        reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('leave_requests').add({
        'name': nameController.text.trim(),
        'rollNo': rollController.text.trim(),
        'year': yearController.text.trim(),
        'department': deptController.text.trim(),
        'section': sectionController.text.trim(),
        'fromDate': fromDateController.text.trim(),
        'toDate': toDateController.text.trim(),
        'reason': reasonController.text.trim(),
        'status': 'Pending', // default
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Leave request submitted ✅")),
      );

      // Clear fields
      nameController.clear();
      rollController.clear();
      yearController.clear();
      deptController.clear();
      sectionController.clear();
      fromDateController.clear();
      toDateController.clear();
      reasonController.clear();

      // Go back to leave list screen
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Leave Request"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rollController,
              decoration: const InputDecoration(
                labelText: "Roll No *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: "Year",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: deptController,
              decoration: const InputDecoration(
                labelText: "Department",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: sectionController,
              decoration: const InputDecoration(
                labelText: "Section",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fromDateController,
              decoration: const InputDecoration(
                labelText: "From Date *",
                hintText: "DD/MM/YYYY",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: toDateController,
              decoration: const InputDecoration(
                labelText: "To Date *",
                hintText: "DD/MM/YYYY",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Reason *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitLeaveRequest,
                child: const Text("Submit Leave Request"),
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

class AddLeaveScreen extends StatefulWidget {
  const AddLeaveScreen({super.key});

  @override
  State<AddLeaveScreen> createState() => _AddLeaveScreenState();
}

class _AddLeaveScreenState extends State<AddLeaveScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  // ✅ Date Picker Function (Without intl)
  Future<void> selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  Future<void> submitLeaveRequest() async {
    if (nameController.text.isEmpty ||
        rollController.text.isEmpty ||
        fromDateController.text.isEmpty ||
        toDateController.text.isEmpty ||
        reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('leave_requests').add({
        'name': nameController.text.trim(),
        'rollNo': rollController.text.trim(),
        'year': yearController.text.trim(),
        'department': deptController.text.trim(),
        'section': sectionController.text.trim(),
        'fromDate': fromDateController.text.trim(),
        'toDate': toDateController.text.trim(),
        'reason': reasonController.text.trim(),
        'status': 'Pending',
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Leave request submitted successfully ✅")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool readOnly = false, VoidCallback? onTap, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Leave Request"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField(nameController, "Name *", Icons.person),
            buildTextField(rollController, "Roll No *", Icons.badge),
            buildTextField(yearController, "Year", Icons.school),
            buildTextField(deptController, "Department", Icons.apartment),
            buildTextField(sectionController, "Section", Icons.group),

            // From Date
            buildTextField(
              fromDateController,
              "From Date *",
              Icons.calendar_today,
              readOnly: true,
              onTap: () => selectDate(fromDateController),
            ),

            // To Date
            buildTextField(
              toDateController,
              "To Date *",
              Icons.calendar_month,
              readOnly: true,
              onTap: () => selectDate(toDateController),
            ),

            buildTextField(
                reasonController, "Reason *", Icons.edit_note,
                maxLines: 3),

            const SizedBox(height: 20),

            // ✅ Stylish Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: submitLeaveRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "SUBMIT LEAVE REQUEST",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
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
