/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_lab_booking_screen.dart';

class LabBookingScreen extends StatelessWidget {
  const LabBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Lab Bookings"),
        centerTitle: true,
      ),

      // ✅ Floating + button to add new booking
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddLabBookingScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

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

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No lab bookings submitted yet"));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Booking ${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text("Lab Name: ${data['labName']}"),
                      Text("Section: ${data['section']}  Year: ${data['year']}"),
                      Text("Periods Required: ${data['periods']}"),
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
}*/


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_lab_booking_screen.dart';

class LabBookingScreen extends StatelessWidget {
  const LabBookingScreen({super.key});

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
      // ✅ Gradient AppBar
      appBar: AppBar(
        title: const Text("My Lab Bookings"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      // ✅ Stylish Floating Button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add),
        label: const Text(
          "New Booking",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddLabBookingScreen(),
            ),
          );
        },
      ),

      // ✅ Background Color
      body: Container(
        color: Colors.grey[100],
        child: StreamBuilder<QuerySnapshot>(
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

            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No lab bookings submitted yet",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final bookings = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final data =
                    bookings[index].data() as Map<String, dynamic>;

                String status = data['status'] ?? 'Pending';

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFE3F2FD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // 🔹 Lab Name
                        Row(
                          children: [
                            const Icon(Icons.science,
                                color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              data['labName'] ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // 🔹 Details
                        Text(
                          "Section: ${data['section'] ?? ""}   |   Year: ${data['year'] ?? ""}",
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Periods Required: ${data['periods'] ?? ""}",
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 12),

                        // 🔹 Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: getStatusColor(status)
                                .withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: getStatusColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 🔹 Staff Remark
                        if (data['staffRemark'] != null &&
                            data['staffRemark']
                                .toString()
                                .isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.comment,
                                    size: 18,
                                    color: Colors.grey),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    data['staffRemark'],
                                    style: const TextStyle(
                                      fontStyle:
                                          FontStyle.italic,
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
              },
            );
          },
        ),
      ),
    );
  }
}



