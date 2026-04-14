/*import 'package:flutter/material.dart';

class StaffHostelScreen extends StatefulWidget {
  const StaffHostelScreen({super.key});

  @override
  State<StaffHostelScreen> createState() => _StaffHostelScreenState();
}

class _StaffHostelScreenState extends State<StaffHostelScreen> {
  String? selectedStatus;
  TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hostel Requests")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: const Text("Student A"),
                      subtitle: const Text("Issue: Broken bed"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("Student B"),
                      subtitle: const Text("Issue: Water leakage"),
                    ),
                  ),
                ],
              ),
            ),
            DropdownButtonFormField<String>(
              hint: const Text("Update Status"),
              value: selectedStatus,
              items: const [
                DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                DropdownMenuItem(value: 'Solved', child: Text('Solved')),
                DropdownMenuItem(value: 'Rejected', child: Text('Rejected')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
            ),
            if (selectedStatus == "Rejected")
              TextField(
                controller: reasonController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Type reason for rejection...",
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("Status: $selectedStatus");
                if (selectedStatus == "Rejected") {
                  print("Reason: ${reasonController.text}");
                }
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Status Updated")));
              },
              child: const Text("Update Status"),
            ),
          ],
        ),
      ),
    );
  }
}*/



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffHostelScreen extends StatefulWidget {
  const StaffHostelScreen({super.key});

  @override
  State<StaffHostelScreen> createState() => _StaffHostelScreenState();
}

class _StaffHostelScreenState extends State<StaffHostelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hostel Requests")),

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
              final docId = requests[index].id;

              // Controller for remarks per card
              TextEditingController remarkController =
                  TextEditingController(text: data['staffRemark'] ?? '');
              String currentStatus = data['status'] ?? 'Pending';

              Color getStatusColor(String status) {
                if (status == "Approved") return Colors.green;
                if (status == "Rejected") return Colors.red;
                return Colors.orange; // Pending
              }

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Student: ${data['studentName']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Room: ${data['roomNumber']}"),
                      const SizedBox(height: 4),
                      Text("Problem: ${data['problemDescription']}"),
                      const SizedBox(height: 6),
                      Text(
                        "Current Status: $currentStatus",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(currentStatus)),
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
                      const Divider(height: 16, thickness: 1),

                      // Buttons for Approve / Reject
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('hostel_requests')
                                    .doc(docId)
                                    .update({
                                  'status': 'Approved',
                                  'staffRemark':
                                      remarkController.text.trim(),
                                });

                                setState(() {
                                  data['status'] = 'Approved';
                                  data['staffRemark'] =
                                      remarkController.text.trim();
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Marked as Approved ✅")));
                              },
                              child: const Text("Approve"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () async {
                                if (remarkController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please provide a reason for rejection")),
                                  );
                                  return;
                                }

                                await FirebaseFirestore.instance
                                    .collection('hostel_requests')
                                    .doc(docId)
                                    .update({
                                  'status': 'Rejected',
                                  'staffRemark':
                                      remarkController.text.trim(),
                                });

                                setState(() {
                                  data['status'] = 'Rejected';
                                  data['staffRemark'] =
                                      remarkController.text.trim();
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Marked as Rejected ❌")));
                              },
                              child: const Text("Reject"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // TextField for remark / reason
                      TextField(
                        controller: remarkController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Add staff remark (required if Reject)",
                          border: OutlineInputBorder(),
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

