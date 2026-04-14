import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_hostel_request_screen.dart'; // import the new floating screen

class HostelRequestScreen extends StatefulWidget {
  const HostelRequestScreen({super.key});

  @override
  State<HostelRequestScreen> createState() => _HostelRequestScreenState();
}

class _HostelRequestScreenState extends State<HostelRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hostel Requests")),

      // StreamBuilder shows previous requests live
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('hostel_requests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(child: Text("No hostel requests found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;

              Color getStatusColor(String status) {
                if (status == "Approved") return Colors.green;
                if (status == "Rejected") return Colors.red;
                return Colors.orange; // Pending
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${data['studentName']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Room: ${data['roomNumber']}"),
                      const SizedBox(height: 4),
                      Text("Problem: ${data['problemDescription']}"),
                      const SizedBox(height: 6),
                      Text(
                        "Status: ${data['status'] ?? 'Pending'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(data['status'] ?? 'Pending')),
                      ),
                      if (data['staffRemark'] != null &&
                          data['staffRemark'].toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Staff Remark: ${data['staffRemark']}",
                            style:
                                const TextStyle(fontStyle: FontStyle.italic),
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

      // Floating button opens the separate add request screen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddHostelRequestScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

