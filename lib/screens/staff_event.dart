import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffEventScreen extends StatefulWidget {
  const StaffEventScreen({super.key});

  @override
  State<StaffEventScreen> createState() => _StaffEventScreenState();
}

class _StaffEventScreenState extends State<StaffEventScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Event Handling",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('event_registrations').snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;

          Map<String, List<QueryDocumentSnapshot>> groupedEvents = {};

          for (var doc in docs) {
            String eventName = doc['eventName'];
            if (!groupedEvents.containsKey(eventName)) {
              groupedEvents[eventName] = [];
            }
            groupedEvents[eventName]!.add(doc);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: groupedEvents.entries.map((entry) {

              String eventName = entry.key;
              List<QueryDocumentSnapshot> students = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Event Title
                    Text(
                      eventName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// Scrollable Table
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.deepPurple.shade100,
                        ),
                        columns: const [
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Roll No")),
                          DataColumn(label: Text("Section")),
                          DataColumn(label: Text("Department")),
                          DataColumn(label: Text("Email")),
                          DataColumn(label: Text("Phone")),
                        ],
                        rows: students.map((doc) {
                          return DataRow(cells: [
                            DataCell(Text(doc['name'] ?? "")),
                            DataCell(Text(doc['rollNo'] ?? "")),
                            DataCell(Text(doc['section'] ?? "")),
                            DataCell(Text(doc['department'] ?? "")),
                            DataCell(Text(doc['email'] ?? "")),
                            DataCell(Text(doc['phone'] ?? "")),
                          ]);
                        }).toList(),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

