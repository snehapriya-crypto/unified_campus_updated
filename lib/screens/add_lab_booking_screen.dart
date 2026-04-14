/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddLabBookingScreen extends StatefulWidget {
  const AddLabBookingScreen({super.key});

  @override
  State<AddLabBookingScreen> createState() => _AddLabBookingScreenState();
}

class _AddLabBookingScreenState extends State<AddLabBookingScreen> {
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController labNameController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  Future<void> submitLabBooking() async {
    if (sectionController.text.isEmpty ||
        yearController.text.isEmpty ||
        labNameController.text.isEmpty ||
        periodController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('lab_bookings').add({
        'section': sectionController.text.trim(),
        'year': yearController.text.trim(),
        'labName': labNameController.text.trim(),
        'periods': periodController.text.trim(),
        'status': 'Pending',
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lab booking submitted ✅")),
      );

      // Clear fields
      sectionController.clear();
      yearController.clear();
      labNameController.clear();
      periodController.clear();

      // Go back to booking list
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
        title: const Text("Add Lab Booking"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: sectionController,
              decoration: const InputDecoration(
                labelText: "Section *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: "Year *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: labNameController,
              decoration: const InputDecoration(
                labelText: "Lab Name *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: periodController,
              decoration: const InputDecoration(
                labelText: "No. of Periods Required *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitLabBooking,
                child: const Text("Submit Lab Booking"),
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

class AddLabBookingScreen extends StatefulWidget {
  const AddLabBookingScreen({super.key});

  @override
  State<AddLabBookingScreen> createState() =>
      _AddLabBookingScreenState();
}

class _AddLabBookingScreenState
    extends State<AddLabBookingScreen> {
  final TextEditingController sectionController =
      TextEditingController();
  final TextEditingController yearController =
      TextEditingController();
  final TextEditingController labNameController =
      TextEditingController();
  final TextEditingController periodController =
      TextEditingController();

  Future<void> submitLabBooking() async {
    if (sectionController.text.isEmpty ||
        yearController.text.isEmpty ||
        labNameController.text.isEmpty ||
        periodController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('lab_bookings')
          .add({
        'section': sectionController.text.trim(),
        'year': yearController.text.trim(),
        'labName': labNameController.text.trim(),
        'periods': periodController.text.trim(),
        'status': 'Pending',
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Lab booking submitted successfully ✅")),
      );

      sectionController.clear();
      yearController.clear();
      labNameController.clear();
      periodController.clear();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  InputDecoration customDecoration(
      String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Gradient AppBar
      appBar: AppBar(
        title: const Text("Add Lab Booking"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
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
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  // Section
                  TextField(
                    controller: sectionController,
                    decoration: customDecoration(
                        "Section *", Icons.group),
                  ),

                  const SizedBox(height: 15),

                  // Year
                  TextField(
                    controller: yearController,
                    decoration: customDecoration(
                        "Year *", Icons.school),
                  ),

                  const SizedBox(height: 15),

                  // Lab Name
                  TextField(
                    controller: labNameController,
                    decoration: customDecoration(
                        "Lab Name *", Icons.science),
                  ),

                  const SizedBox(height: 15),

                  // Periods
                  TextField(
                    controller: periodController,
                    keyboardType: TextInputType.number,
                    decoration: customDecoration(
                        "No. of Periods Required *",
                        Icons.timer),
                  ),

                  const SizedBox(height: 30),

                  // ✅ Stylish Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: submitLabBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1565C0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Submit Lab Booking",
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
