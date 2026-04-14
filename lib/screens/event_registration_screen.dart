/*import 'package:flutter/material.dart';

class EventRegistrationScreen extends StatefulWidget {
  const EventRegistrationScreen({super.key});

  @override
  State<EventRegistrationScreen> createState() => _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final emailController = TextEditingController();
  final sectionController = TextEditingController();
  final eventNameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: rollController, decoration: const InputDecoration(labelText: "Roll No")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: sectionController, decoration: const InputDecoration(labelText: "Section")),
              TextField(controller: eventNameController, decoration: const InputDecoration(labelText: "Event Name")),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Event Registration Submitted")),
                  );
                },
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EventRegistrationScreen extends StatefulWidget {
  const EventRegistrationScreen({super.key});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState
    extends State<EventRegistrationScreen> {
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final emailController = TextEditingController();
  final sectionController = TextEditingController();
  final departmentController = TextEditingController();
  final eventNameController = TextEditingController();
  final phoneController = TextEditingController();

  Widget buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide:
                const BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),

      appBar: AppBar(
        title: const Text(
          "Event Registration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🟣 Top Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.event_available,
                size: 60,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 25),

            /// 🔹 Form Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: [

                  buildTextField(
                    controller: nameController,
                    label: "Full Name",
                    icon: Icons.person,
                  ),

                  buildTextField(
                    controller: rollController,
                    label: "Roll Number",
                    icon: Icons.badge,
                  ),

                  buildTextField(
                    controller: sectionController,
                    label: "Section",
                    icon: Icons.group,
                  ),

                  buildTextField(
                    controller: departmentController,
                    label: "Department",
                    icon: Icons.school,
                  ),

                  buildTextField(
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  buildTextField(
                    controller: phoneController,
                    label: "Phone Number",
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),

                  buildTextField(
                    controller: eventNameController,
                    label: "Event Name",
                    icon: Icons.celebration,
                  ),

                  const SizedBox(height: 10),

                  /// 🟣 SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Event Registration Submitted ✅"),
                          ),
                        );
                      },
                      child: const Text(
                        "Submit Registration",
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
          ],
        ),
      ),
    );
  }
}*/




import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRegistrationScreen extends StatefulWidget {
  const EventRegistrationScreen({super.key});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState
    extends State<EventRegistrationScreen> {
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final sectionController = TextEditingController();
  final departmentController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final eventNameController = TextEditingController();

  Future<void> submitEvent() async {
    if (nameController.text.isEmpty ||
        rollController.text.isEmpty ||
        sectionController.text.isEmpty ||
        departmentController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        eventNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('event_registrations')
        .add({
      'name': nameController.text.trim(),
      'rollNo': rollController.text.trim(),
      'section': sectionController.text.trim(),
      'department': departmentController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'eventName': eventNameController.text.trim(),
      'timestamp': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Registration Submitted ✅")),
    );

    Navigator.pop(context);
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.deepPurple.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),

      appBar: AppBar(
        title: const Text(
          "Event Registration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(controller: nameController, decoration: inputStyle("Name")),
            const SizedBox(height: 12),

            TextField(controller: rollController, decoration: inputStyle("Roll No")),
            const SizedBox(height: 12),

            TextField(controller: sectionController, decoration: inputStyle("Section")),
            const SizedBox(height: 12),

            TextField(controller: departmentController, decoration: inputStyle("Department")),
            const SizedBox(height: 12),

            TextField(controller: emailController, decoration: inputStyle("Email")),
            const SizedBox(height: 12),

            TextField(controller: phoneController, decoration: inputStyle("Phone Number")),
            const SizedBox(height: 12),

            TextField(controller: eventNameController, decoration: inputStyle("Event Name")),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: submitEvent,
                child: const Text(
                  "SUBMIT REGISTRATION",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,   // ✅ TEXT CLEARLY VISIBLE
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


