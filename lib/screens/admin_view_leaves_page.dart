import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewLeavesPage extends StatefulWidget {
  const AdminViewLeavesPage({super.key});

  @override
  State<AdminViewLeavesPage> createState() => _AdminViewLeavesPageState();
}

class _AdminViewLeavesPageState extends State<AdminViewLeavesPage> {
  String? selectedYear;
  String? selectedDepartment;
  String? selectedSection;

  final List<String> years = ['1', '2', '3', '4'];
  final List<String> departments = ['CSE', 'IT', 'ECE', 'EEE', 'Cybersecurity', 'IoT', 'AIDS'];
  final List<String> sections = ['A', 'B', 'C'];

  Query get query {
    Query q = FirebaseFirestore.instance.collection('leave_requests');

    if (selectedYear != null) {
      q = q.where('year', isEqualTo: selectedYear);
    }
    if (selectedDepartment != null) {
      q = q.where('department', isEqualTo: selectedDepartment);
    }
    if (selectedSection != null) {
      q = q.where('section', isEqualTo: selectedSection);
    }

    return q;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("View Leave Requests", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        hint: "Year",
                        value: selectedYear,
                        items: years,
                        onChanged: (val) => setState(() => selectedYear = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _dropdown(
                        hint: "Section",
                        value: selectedSection,
                        items: sections,
                        onChanged: (val) => setState(() => selectedSection = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _dropdown(
                  hint: "Department",
                  value: selectedDepartment,
                  items: departments,
                  onChanged: (val) => setState(() => selectedDepartment = val),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("No leave requests found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['reason'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("Name: ${data['name']}"),
                          Text("Roll No: ${data['rollNo']}"),
                          Text("Dept: ${data['department']} | Year: ${data['year']} | Section: ${data['section']}"),
                          const SizedBox(height: 6),
                          Text("From: ${data['fromDate']}  To: ${data['toDate']}"),
                          const SizedBox(height: 6),
                          Text("Status: ${data['status']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
