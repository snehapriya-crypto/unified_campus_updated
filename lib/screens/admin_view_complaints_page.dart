/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewComplaintsPage extends StatefulWidget {
  const AdminViewComplaintsPage({super.key});

  @override
  State<AdminViewComplaintsPage> createState() =>
      _AdminViewComplaintsPageState();
}

class _AdminViewComplaintsPageState extends State<AdminViewComplaintsPage> {
  String? selectedYear;
  String? selectedDepartment;
  String? selectedSection;

  final List<String> years = ['1', '2', '3', '4'];
  final List<String> departments = [
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'Cybersecurity',
    'IoT',
    'AIDS',
  ];
  final List<String> sections = ['A', 'B', 'C'];

  Query get query {
    Query q = FirebaseFirestore.instance.collection('complaints');

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
      appBar: AppBar(
        title: const Text("View Complaints"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // 🔽 FILTERS (NO SCROLL ISSUE)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _dropdown(
                        hint: "Year",
                        value: selectedYear,
                        items: years,
                        onChanged: (val) =>
                            setState(() => selectedYear = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: _dropdown(
                        hint: "Section",
                        value: selectedSection,
                        items: sections,
                        onChanged: (val) =>
                            setState(() => selectedSection = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _dropdown(
                  hint: "Department",
                  value: selectedDepartment,
                  items: departments,
                  onChanged: (val) =>
                      setState(() => selectedDepartment = val),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 📄 COMPLAINT LIST (ONLY ONE Expanded)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("Something went wrong"));
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                      child: Text("No complaints found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data() as Map<String, dynamic>;
                    final status = data['status'] ?? 'Pending';

                    Color statusColor;
                    switch (status) {
                      case 'Solved':
                        statusColor = Colors.green;
                        break;
                      case 'Rejected':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.orange;
                    }

                    return Card(
                      elevation: 3,
                      margin:
                          const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['complaint'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text("Name: ${data['name'] ?? 'N/A'}"),
                            Text(
                                "Roll No: ${data['rollNo'] ?? 'N/A'}"),
                            Text(
                              "Dept: ${data['department']} | "
                              "Year: ${data['year']} | "
                              "Section: ${data['section']}",
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Status: $status",
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  // 🔽 DROPDOWN (NO Expanded HERE ❌)
  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
    );
  }
}*/



/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewComplaintsPage extends StatefulWidget {
  const AdminViewComplaintsPage({super.key});

  @override
  State<AdminViewComplaintsPage> createState() =>
      _AdminViewComplaintsPageState();
}

class _AdminViewComplaintsPageState
    extends State<AdminViewComplaintsPage> {
  String? selectedYear;
  String? selectedDepartment;
  String? selectedSection;

  final List<String> years = ['1', '2', '3', '4'];
  final List<String> departments = [
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'Cybersecurity',
    'IoT',
    'AIDS',
  ];
  final List<String> sections = ['A', 'B', 'C'];

  Query get query {
    Query q =
        FirebaseFirestore.instance.collection('complaints');

    if (selectedYear != null) {
      q = q.where('year', isEqualTo: selectedYear);
    }
    if (selectedDepartment != null) {
      q = q.where('department',
          isEqualTo: selectedDepartment);
    }
    if (selectedSection != null) {
      q = q.where('section',
          isEqualTo: selectedSection);
    }

    return q;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "View Complaints",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
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

          /// 🔽 FILTER SECTION
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
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
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                              0.42,
                      child: _dropdown(
                        hint: "Year",
                        value: selectedYear,
                        items: years,
                        onChanged: (val) =>
                            setState(
                                () => selectedYear = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                              0.42,
                      child: _dropdown(
                        hint: "Section",
                        value: selectedSection,
                        items: sections,
                        onChanged: (val) =>
                            setState(() =>
                                selectedSection = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _dropdown(
                  hint: "Department",
                  value: selectedDepartment,
                  items: departments,
                  onChanged: (val) => setState(
                      () => selectedDepartment = val),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// 📄 COMPLAINT LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child:
                          Text("Something went wrong"));
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                      child:
                          Text("No complaints found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder:
                      (context, index) {
                    final data = docs[index].data()
                        as Map<String, dynamic>;
                    final status =
                        data['status'] ?? 'Pending';

                    Color statusColor;
                    switch (status) {
                      case 'Solved':
                        statusColor = Colors.green;
                        break;
                      case 'Rejected':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.orange;
                    }

                    return Container(
                      margin:
                          const EdgeInsets.symmetric(
                              vertical: 8),
                      padding:
                          const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 8,
                            offset:
                                const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['complaint'] ?? '',
                            style:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "Name: ${data['name'] ?? 'N/A'}"),
                          Text(
                              "Roll No: ${data['rollNo'] ?? 'N/A'}"),
                          Text(
                            "Dept: ${data['department']} | "
                            "Year: ${data['year']} | "
                            "Section: ${data['section']}",
                          ),
                          const SizedBox(height: 10),

                          /// STATUS BADGE
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                                        horizontal: 12,
                                        vertical: 6),
                            decoration:
                                BoxDecoration(
                              color: statusColor
                                  .withOpacity(0.15),
                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
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
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14),
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewComplaintsPage extends StatefulWidget {
  const AdminViewComplaintsPage({super.key});

  @override
  State<AdminViewComplaintsPage> createState() =>
      _AdminViewComplaintsPageState();
}

class _AdminViewComplaintsPageState
    extends State<AdminViewComplaintsPage> {
  String? selectedYear;
  String? selectedDepartment;
  String? selectedSection;

  final List<String> years = ['1', '2', '3', '4'];
  final List<String> departments = [
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'Cybersecurity',
    'IoT',
    'AIDS',
  ];
  final List<String> sections = ['A', 'B', 'C'];

  Query get query {
    Query q =
        FirebaseFirestore.instance.collection('complaints');

    if (selectedYear != null) {
      q = q.where('year', isEqualTo: selectedYear);
    }
    if (selectedDepartment != null) {
      q = q.where('department',
          isEqualTo: selectedDepartment);
    }
    if (selectedSection != null) {
      q = q.where('section',
          isEqualTo: selectedSection);
    }

    return q;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "View Complaints",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
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

          /// 🔽 FILTER SECTION
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
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
            child: Column(
              children: [

                /// FIXED OVERFLOW HERE
                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        hint: "Year",
                        value: selectedYear,
                        items: years,
                        onChanged: (val) =>
                            setState(() => selectedYear = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _dropdown(
                        hint: "Section",
                        value: selectedSection,
                        items: sections,
                        onChanged: (val) => setState(
                            () => selectedSection = val),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                _dropdown(
                  hint: "Department",
                  value: selectedDepartment,
                  items: departments,
                  onChanged: (val) => setState(
                      () => selectedDepartment = val),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// 📄 COMPLAINT LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("Something went wrong"));
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                      child: Text("No complaints found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data()
                        as Map<String, dynamic>;
                    final status =
                        data['status'] ?? 'Pending';

                    Color statusColor;
                    switch (status) {
                      case 'Solved':
                        statusColor = Colors.green;
                        break;
                      case 'Rejected':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.orange;
                    }

                    return Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['complaint'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "Name: ${data['name'] ?? 'N/A'}"),
                          Text(
                              "Roll No: ${data['rollNo'] ?? 'N/A'}"),
                          Text(
                            "Dept: ${data['department']} | "
                            "Year: ${data['year']} | "
                            "Section: ${data['section']}",
                          ),
                          const SizedBox(height: 10),

                          /// STATUS BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor
                                  .withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 14),
      ),
    );
  }
}



