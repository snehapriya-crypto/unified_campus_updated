/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffComplaints extends StatelessWidget {
  const StaffComplaints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Complaints"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No complaints found"),
            );
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final data =
                  complaints[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("Roll No: ${data['rollNo'] ?? '-'}"),
                      Text("Year: ${data['year'] ?? '-'}"),
                      Text("Department: ${data['department'] ?? '-'}"),
                      Text("Section: ${data['section'] ?? '-'}"),
                      const SizedBox(height: 8),
                      const Text(
                        "Complaint:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data['complaint'] ?? ''),
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

class StaffComplaints extends StatelessWidget {
  const StaffComplaints({super.key});

  // Dialog for updating status
  void _updateStatus(
    BuildContext context,
    String docId,
    String status,
  ) {
    TextEditingController reasonController = TextEditingController();

    if (status == "Rejected") {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Reason for Rejection"),
            content: TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter reason",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('complaints')
                      .doc(docId)
                      .update({
                    'status': status,
                    'staffReason': reasonController.text,
                  });

                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          );
        },
      );
    } else {
      FirebaseFirestore.instance
          .collection('complaints')
          .doc(docId)
          .update({
        'status': status,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Complaints"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
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
            return const Center(child: Text("No complaints found"));
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final doc = complaints[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Roll No: ${data['rollNo'] ?? '-'}"),
                      Text("Year: ${data['year'] ?? '-'}"),
                      Text("Department: ${data['department'] ?? '-'}"),
                      Text("Section: ${data['section'] ?? '-'}"),
                      const SizedBox(height: 8),
                      const Text(
                        "Complaint:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(data['complaint'] ?? ''),
                      const SizedBox(height: 10),

                      // STATUS TEXT
                      Text(
                        "Status: ${data['status'] ?? 'Pending'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data['status'] == 'Solved'
                              ? Colors.green
                              : data['status'] == 'Rejected'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),

                      if (data['staffReason'] != null &&
                          data['staffReason'] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "Reason: ${data['staffReason']}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      const SizedBox(height: 10),

                      // BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => _updateStatus(
                              context,
                              doc.id,
                              "Solved",
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text("Solved"),
                          ),
                          ElevatedButton(
                            onPressed: () => _updateStatus(
                              context,
                              doc.id,
                              "Pending",
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            child: const Text("Pending"),
                          ),
                          ElevatedButton(
                            onPressed: () => _updateStatus(
                              context,
                              doc.id,
                              "Rejected",
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text("Rejected"),
                          ),
                        ],
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

class StaffComplaints extends StatelessWidget {
  const StaffComplaints({super.key});

  void _updateStatus(BuildContext context, String docId, String status) {
    TextEditingController reasonController = TextEditingController();

    if (status == "Rejected") {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Reason for Rejection"),
            content: TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter reason",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('complaints')
                      .doc(docId)
                      .update({
                    'status': status,
                    'staffReason': reasonController.text,
                  });

                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          );
        },
      );
    } else {
      FirebaseFirestore.instance
          .collection('complaints')
          .doc(docId)
          .update({
        'status': status,
      });
    }
  }

  Color getPriorityColor(String priority) {
    if (priority == "High") {
      return Colors.red;
    } else if (priority == "Medium") {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Complaints"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
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
            return const Center(child: Text("No complaints found"));
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: complaints.length,
            itemBuilder: (context, index) {

              final doc = complaints[index];
              final data = doc.data() as Map<String, dynamic>;

              String priority = data['priority'] ?? "Medium";

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        data['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text("Roll No: ${data['rollNo'] ?? '-'}"),
                      Text("Year: ${data['year'] ?? '-'}"),
                      Text("Department: ${data['department'] ?? '-'}"),
                      Text("Section: ${data['section'] ?? '-'}"),

                      const SizedBox(height: 8),

                      const Text(
                        "Complaint:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text(data['complaint'] ?? ''),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: getPriorityColor(priority)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Priority: $priority",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getPriorityColor(priority),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Status: ${data['status'] ?? 'Pending'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data['status'] == 'Solved'
                              ? Colors.green
                              : data['status'] == 'Rejected'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),

                      if (data['staffReason'] != null &&
                          data['staffReason'] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "Reason: ${data['staffReason']}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _updateStatus(context, doc.id, "Solved"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text("Solved"),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _updateStatus(context, doc.id, "Pending"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            child: const Text("Pending"),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _updateStatus(context, doc.id, "Rejected"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text("Rejected"),
                          ),
                        ],
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

class StaffComplaints extends StatelessWidget {
  const StaffComplaints({super.key});

  void _updateStatus(BuildContext context, String docId, String status) {
    TextEditingController reasonController = TextEditingController();

    if (status == "Rejected") {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Reason for Rejection"),
            content: TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter reason",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('complaints')
                      .doc(docId)
                      .update({
                    'status': status,
                    'staffReason': reasonController.text,
                  });

                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          );
        },
      );
    } else {
      FirebaseFirestore.instance
          .collection('complaints')
          .doc(docId)
          .update({
        'status': status,
      });
    }
  }

  Color getPriorityColor(String priority) {
    if (priority == "High") {
      return Colors.red;
    } else if (priority == "Medium") {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Complaints"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
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
            return const Center(child: Text("No complaints found"));
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final doc = complaints[index];
              final data = doc.data() as Map<String, dynamic>;

              String priority = data['priority'] ?? "Medium";

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Roll No: ${data['rollNo'] ?? '-'}"),
                      Text("Year: ${data['year'] ?? '-'}"),
                      Text("Department: ${data['department'] ?? '-'}"),
                      Text("Section: ${data['section'] ?? '-'}"),

                      const SizedBox(height: 8),

                      const Text(
                        "Complaint:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text(data['complaint'] ?? ''),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: getPriorityColor(priority)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Priority: $priority",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getPriorityColor(priority),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Status: ${data['status'] ?? 'Pending'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data['status'] == 'Solved'
                              ? Colors.green
                              : data['status'] == 'Rejected'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),

                      if (data['staffReason'] != null &&
                          data['staffReason'] != "")
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            "Reason: ${data['staffReason']}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      const SizedBox(height: 10),

                      // FIXED OVERFLOW ISSUE HERE
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _updateStatus(context, doc.id, "Solved"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text("Solved"),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _updateStatus(context, doc.id, "Pending"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            child: const Text("Pending"),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                _updateStatus(context, doc.id, "Rejected"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text("Rejected"),
                          ),
                        ],
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


