/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStudentsPage extends StatelessWidget {
  const ManageStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Students"),
        centerTitle: true,
      ),

      // 🔹 Listen to students data from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'student')
            .snapshots(),

        builder: (context, snapshot) {
          // ❌ Error state
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading students"));
          }

          // ⏳ Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 📄 Get student documents
          final students = snapshot.data!.docs;

          // 📭 No students
          if (students.isEmpty) {
            return const Center(child: Text("No students found"));
          }

          // 📋 Show students list
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final studentDoc = students[index];
              final data = studentDoc.data() as Map<String, dynamic>;

              // ✅ If active not present → assume true
              final bool isActive = data['active'] ?? true;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.person),

                  // 📧 Student email
                  title: Text(data['email'] ?? "No Email"),

                  // 🔴🟢 Status
                  subtitle: Text(
                    isActive ? "Status: Active" : "Status: Disabled",
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // 🔘 Admin control switch
                  trailing: Switch(
                    value: isActive,
                    onChanged: (newValue) {
                      _updateStudentStatus(
                        studentDoc.id,
                        newValue,
                        context,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 🔹 Update student active/disabled status
  void _updateStudentStatus(
    String uid,
    bool status,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'active': status});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status ? "Student enabled" : "Student disabled",
        ),
      ),
    );
  }
}*/



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStudentsPage extends StatelessWidget {
  const ManageStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔷 Gradient AppBar
      appBar: AppBar(
        title: const Text(
          "Manage Students",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'student')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading students"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs;

          if (students.isEmpty) {
            return const Center(child: Text("No students found"));
          }

          return Column(
            children: [

              // 📊 Student Count Header
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4e73df), Color(0xFF1cc88a)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.school,
                        color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      "Total Students: ${students.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 📋 Students List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final studentDoc = students[index];
                    final data =
                        studentDoc.data() as Map<String, dynamic>;

                    final bool isActive =
                        data['active'] ?? true;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(16),

                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              Colors.blue.withOpacity(0.15),
                          child: const Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),

                        title: Text(
                          data['email'] ?? "No Email",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Padding(
                          padding:
                              const EdgeInsets.only(top: 6),
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.green
                                          .withOpacity(0.15)
                                      : Colors.red
                                          .withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isActive
                                      ? "Active"
                                      : "Disabled",
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        trailing: Switch(
                          value: isActive,
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.red,
                          onChanged: (newValue) {
                            _updateStudentStatus(
                              studentDoc.id,
                              newValue,
                              context,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateStudentStatus(
    String uid,
    bool status,
    BuildContext context,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'active': status});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status
              ? "Student enabled successfully"
              : "Student disabled successfully",
        ),
        backgroundColor:
            status ? Colors.green : Colors.red,
      ),
    );
  }
}

