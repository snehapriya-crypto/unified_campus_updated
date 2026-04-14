import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_leave_screen.dart'; // Separate form screen

class LeaveRequestScreen extends StatelessWidget {
  const LeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Leave Requests"),
        centerTitle: true,
      ),

      // ✅ Floating + button to add new leave
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddLeaveScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leave_requests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No leave requests submitted yet"));
          }

          final leaves = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: leaves.length,
            itemBuilder: (context, index) {
              final data = leaves[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Leave Request ${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("From: ${data['fromDate']} → To: ${data['toDate']}"),
                      Text("Reason: ${data['reason']}"),
                      const SizedBox(height: 4),
                      Text(
                        "Status: ${data['status'] ?? 'Pending'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data['status'] == "Approved"
                              ? Colors.green
                              : data['status'] == "Rejected"
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),
                      if (data['staffRemark'] != null &&
                          data['staffRemark'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Staff Remark: ${data['staffRemark']}",
                            style: const TextStyle(
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



