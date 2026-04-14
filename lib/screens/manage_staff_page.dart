/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStaffPage extends StatelessWidget {
  const ManageStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Staff"),
        centerTitle: true,
      ),

      // 🔹 Listen to staff data from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'staff') // ✅ staff only
            .snapshots(),

        builder: (context, snapshot) {
          // ❌ Error state
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading staff"));
          }

          // ⏳ Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final staffList = snapshot.data!.docs;

          // 📭 No staff found
          if (staffList.isEmpty) {
            return const Center(child: Text("No staff found"));
          }

          // 📋 Show staff list
          return ListView.builder(
            itemCount: staffList.length,
            itemBuilder: (context, index) {
              final staffDoc = staffList[index];
              final data = staffDoc.data() as Map<String, dynamic>;

              // ✅ Default active = true
              final bool isActive = data['active'] ?? true;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.person),

                  // 👤 Staff email
                  title: Text(data['email'] ?? "No Email"),

                  // 🔴🟢 Status text (JUST LIKE STUDENTS)
                  subtitle: Text(
                    isActive ? "Status: Active" : "Status: Disabled",
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // 🔘 Admin toggle switch
                  trailing: Switch(
                    value: isActive,
                    onChanged: (newValue) {
                      _updateStaffStatus(
                        staffDoc.id,
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

  // 🔹 Update staff active/disabled status
  void _updateStaffStatus(
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
          status ? "Staff enabled" : "Staff disabled",
        ),
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStaffPage extends StatelessWidget {
  const ManageStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔷 Gradient AppBar
      appBar: AppBar(
        title: const Text(
          "Manage Staff",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'staff')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading staff"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final staffList = snapshot.data!.docs;

          if (staffList.isEmpty) {
            return const Center(child: Text("No staff found"));
          }

          return Column(
            children: [

              // 📊 Staff Count Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.groups,
                        color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      "Total Staff: ${staffList.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // 📋 Staff List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: staffList.length,
                  itemBuilder: (context, index) {
                    final staffDoc = staffList[index];
                    final data =
                        staffDoc.data() as Map<String, dynamic>;

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
                              Colors.teal.withOpacity(0.15),
                          child: const Icon(
                            Icons.person,
                            color: Colors.teal,
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
                            _updateStaffStatus(
                              staffDoc.id,
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

  void _updateStaffStatus(
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
              ? "Staff enabled successfully"
              : "Staff disabled successfully",
        ),
        backgroundColor:
            status ? Colors.green : Colors.red,
      ),
    );
  }
}



