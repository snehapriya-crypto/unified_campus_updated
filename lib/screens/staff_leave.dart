/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffLeaveScreen extends StatefulWidget {
  const StaffLeaveScreen({super.key});

  @override
  State<StaffLeaveScreen> createState() => _StaffLeaveScreenState();
}

class _StaffLeaveScreenState extends State<StaffLeaveScreen> {
  final TextEditingController adviceController = TextEditingController();

  /// 🔹 Update leave status in Firestore
  Future<void> updateLeaveStatus(
    String docId,
    String status,
    String advice,
  ) async {
    await FirebaseFirestore.instance
        .collection('leave_requests')
        .doc(docId)
        .update({
      'status': status,
      'staffAdvice': advice,
    });

    adviceController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Leave $status")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Requests (Staff)"),
        centerTitle: true,
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
            return const Center(child: Text("No leave requests"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${data['name']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Roll No: ${data['rollNo']}"),
                      const SizedBox(height: 6),

                      Text("Reason: ${data['reason']}"),
                      Text(
                          "Date: ${data['fromDate']} → ${data['toDate']}"),
                      const SizedBox(height: 8),

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
                      const SizedBox(height: 10),

                      /// 🔹 Action buttons only if Pending
                      if (data['status'] == 'Pending') ...[
                        TextField(
                          controller: adviceController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText:
                                "Advice / Reason (optional for approval)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  updateLeaveStatus(
                                    doc.id,
                                    "Approved",
                                    adviceController.text.trim(),
                                  );
                                },
                                child: const Text("Approve"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  updateLeaveStatus(
                                    doc.id,
                                    "Rejected",
                                    adviceController.text.trim(),
                                  );
                                },
                                child: const Text("Reject"),
                              ),
                            ),
                          ],
                        ),
                      ],

                      /// 🔹 Show advice after update
                      if (data['status'] != 'Pending' &&
                          data['staffAdvice'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Staff Advice: ${data['staffAdvice']}",
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
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

class StaffLeaveScreen extends StatefulWidget {
  const StaffLeaveScreen({super.key});

  @override
  State<StaffLeaveScreen> createState() => _StaffLeaveScreenState();
}

class _StaffLeaveScreenState extends State<StaffLeaveScreen> {

  /// 🔹 Update leave status
  Future<void> updateLeaveStatus(
      String docId, String status, String advice) async {

    await FirebaseFirestore.instance
        .collection('leave_requests')
        .doc(docId)
        .update({
      'status': status,
      'staffAdvice': advice,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Leave $status ✅")),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ✅ Gradient AppBar
      appBar: AppBar(
        title: const Text("Leave Requests"),
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

      body: Container(
        color: Colors.grey[100],

        child: StreamBuilder<QuerySnapshot>(
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
              return const Center(child: Text("No leave requests"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {

                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final adviceController = TextEditingController();

                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.only(bottom: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🔹 Header Row
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            /// Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: getStatusColor(
                                        data['status'] ?? 'Pending')
                                    .withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text(
                                data['status'] ?? 'Pending',
                                style: TextStyle(
                                  color: getStatusColor(
                                      data['status'] ?? 'Pending'),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text("Roll No: ${data['rollNo'] ?? ''}"),
                        Text(
                            "Date: ${data['fromDate']} → ${data['toDate']}"),

                        const SizedBox(height: 8),

                        const Text(
                          "Reason:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Text(data['reason'] ?? ''),

                        const SizedBox(height: 12),

                        /// 🔹 Show Buttons if Pending
                        if (data['status'] == 'Pending') ...[

                          TextField(
                            controller: adviceController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Add Advice (Optional)",
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [

                              /// Approve Button
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.green,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    updateLeaveStatus(
                                      doc.id,
                                      "Approved",
                                      adviceController.text.trim(),
                                    );
                                  },
                                  child: const Text(
                                    "Approve",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// Reject Button
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    updateLeaveStatus(
                                      doc.id,
                                      "Rejected",
                                      adviceController.text.trim(),
                                    );
                                  },
                                  child: const Text(
                                    "Reject",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        /// 🔹 Show Advice After Update
                        if (data['status'] != 'Pending' &&
                            data['staffAdvice'] != null &&
                            data['staffAdvice']
                                .toString()
                                .isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10),
                            child: Text(
                              "Staff Advice: ${data['staffAdvice']}",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black54,
                              ),
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
      ),
    );
  }
}



