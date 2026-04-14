




/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffLabScreen extends StatefulWidget {
  const StaffLabScreen({super.key});

  @override
  State<StaffLabScreen> createState() => _StaffLabScreenState();
}

class _StaffLabScreenState extends State<StaffLabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab Approval Requests")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lab_bookings')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return const Center(child: Text("No lab booking requests"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index].data() as Map<String, dynamic>;
              final docId = bookings[index].id;

              String currentStatus = data['status'] ?? 'Pending';
              TextEditingController commentController = TextEditingController(
                  text: data['staffRemark'] ?? '');

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lab info
                      Text(
                        "Student: ${data['section']} - ${data['year']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Lab: ${data['labName']}"),
                      Text("Periods: ${data['periods']}"),
                      const SizedBox(height: 6),

                      // Status display
                      Text(
                        "Current Status: $currentStatus",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: currentStatus == "Available"
                              ? Colors.green
                              : currentStatus == "Unavailable"
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),

                      // Existing staff remark
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

                      const Divider(height: 16, thickness: 1),

                      // Dropdown to update status
                      DropdownButtonFormField<String>(
                        value: currentStatus == "Pending" ? null : currentStatus,
                        hint: const Text("Update Status"),
                        items: const [
                          DropdownMenuItem(
                              value: 'Available', child: Text('Available')),
                          DropdownMenuItem(
                              value: 'Unavailable', child: Text('Unavailable')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            currentStatus = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),

                      // TextField for staff comment
                      TextField(
                        controller: commentController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Add remark (optional)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Update button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('lab_bookings')
                                  .doc(docId)
                                  .update({
                                'status': currentStatus,
                                'staffRemark': commentController.text.trim(),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Status updated successfully ✅")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Error updating status: $e")));
                            }
                          },
                          child: const Text("Update Status"),
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
}*/


/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffLabScreen extends StatefulWidget {
  const StaffLabScreen({super.key});

  @override
  State<StaffLabScreen> createState() => _StaffLabScreenState();
}

class _StaffLabScreenState extends State<StaffLabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab Approval Requests")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lab_bookings')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return const Center(child: Text("No lab booking requests"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index].data() as Map<String, dynamic>;
              final docId = bookings[index].id;

              // Controllers for each card
              TextEditingController commentController =
                  TextEditingController(text: data['staffRemark'] ?? '');
              String selectedStatus = data['status'] ?? 'Pending';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student & Lab info
                      Text(
                        "Student: ${data['section']} - ${data['year']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Lab: ${data['labName']}"),
                      Text("Periods: ${data['periods']}"),
                      const SizedBox(height: 6),

                      // Current Status
                      Text(
                        "Current Status: ${data['status'] ?? 'Pending'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data['status'] == "Available"
                              ? Colors.green
                              : data['status'] == "Unavailable"
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),

                      // Existing staff remark
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

                      // Dropdown to update status
                      DropdownButtonFormField<String>(
                        value: selectedStatus == "Pending" ? null : selectedStatus,
                        hint: const Text("Update Status"),
                        items: const [
                          DropdownMenuItem(
                              value: 'Available', child: Text('Available')),
                          DropdownMenuItem(
                              value: 'Unavailable', child: Text('Unavailable')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),

                      // TextField for staff comment
                      TextField(
                        controller: commentController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Add remark (optional)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Update button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              // Update Firestore
                              await FirebaseFirestore.instance
                                  .collection('lab_bookings')
                                  .doc(docId)
                                  .update({
                                'status': selectedStatus,
                                'staffRemark': commentController.text.trim(),
                              });

                              // Update local data so UI shows new status immediately
                              setState(() {
                                data['status'] = selectedStatus;
                                data['staffRemark'] = commentController.text.trim();
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Status updated successfully ✅")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Error updating status: $e")));
                            }
                          },
                          child: const Text("Update Status"),
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
}*/


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffLabScreen extends StatefulWidget {
  const StaffLabScreen({super.key});

  @override
  State<StaffLabScreen> createState() => _StaffLabScreenState();
}

class _StaffLabScreenState extends State<StaffLabScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab Approval Requests")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lab_bookings')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return const Center(child: Text("No lab booking requests"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index].data() as Map<String, dynamic>;
              final docId = bookings[index].id;

              // Controller for comment
              TextEditingController commentController =
                  TextEditingController(text: data['staffRemark'] ?? '');

              String currentStatus = data['status'] ?? 'Pending';

              Color getStatusColor(String status) {
                if (status == "Available") return Colors.green;
                if (status == "Unavailable") return Colors.red;
                return Colors.orange;
              }

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student & Lab info
                      Text(
                        "Student: ${data['section']} - ${data['year']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Lab: ${data['labName']}"),
                      Text("Periods: ${data['periods']}"),
                      const SizedBox(height: 6),

                      // Current Status
                      Text(
                        "Current Status: $currentStatus",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: getStatusColor(currentStatus),
                        ),
                      ),

                      // Existing staff remark
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

                      // Buttons for Available / Unavailable
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('lab_bookings')
                                    .doc(docId)
                                    .update({
                                  'status': 'Available',
                                  'staffRemark':
                                      commentController.text.trim(),
                                });

                                setState(() {
                                  data['status'] = 'Available';
                                  data['staffRemark'] =
                                      commentController.text.trim();
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Marked as Available ✅")));
                              },
                              child: const Text("Available"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('lab_bookings')
                                    .doc(docId)
                                    .update({
                                  'status': 'Unavailable',
                                  'staffRemark':
                                      commentController.text.trim(),
                                });

                                setState(() {
                                  data['status'] = 'Unavailable';
                                  data['staffRemark'] =
                                      commentController.text.trim();
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Marked as Unavailable ❌")));
                              },
                              child: const Text("Unavailable"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Comment TextField
                      TextField(
                        controller: commentController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Add remark (optional)",
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




