/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  final List<String> departments = [
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'Cybersecurity',
    'IoT',
    'AIDS',
  ];

  Map<String, int> complaintCount = {};
  Map<String, int> leaveCount = {};

  int pendingComplaints = 0;
  int solvedComplaints = 0;
  int rejectedComplaints = 0;

  int pendingLeaves = 0;
  int approvedLeaves = 0;
  int rejectedLeaves = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    setState(() => isLoading = true);

    complaintCount.clear();
    leaveCount.clear();

    for (var dept in departments) {
      complaintCount[dept] = 0;
      leaveCount[dept] = 0;
    }

    final complaintsSnapshot =
        await FirebaseFirestore.instance.collection('complaints').get();

    final leavesSnapshot =
        await FirebaseFirestore.instance.collection('leave_requests').get();

    pendingComplaints = 0;
    solvedComplaints = 0;
    rejectedComplaints = 0;

    pendingLeaves = 0;
    approvedLeaves = 0;
    rejectedLeaves = 0;

    for (var doc in complaintsSnapshot.docs) {
      final data = doc.data();
      final dept = data['department'];
      final status = data['status'] ?? 'Pending';

      if (complaintCount.containsKey(dept)) {
        complaintCount[dept] = complaintCount[dept]! + 1;
      }

      if (status == 'Pending') pendingComplaints++;
      if (status == 'Solved') solvedComplaints++;
      if (status == 'Rejected') rejectedComplaints++;
    }

    for (var doc in leavesSnapshot.docs) {
      final data = doc.data();
      final dept = data['department'];
      final status = data['status'] ?? 'Pending';

      if (leaveCount.containsKey(dept)) {
        leaveCount[dept] = leaveCount[dept]! + 1;
      }

      if (status == 'Pending') pendingLeaves++;
      if (status == 'Approved') approvedLeaves++;
      if (status == 'Rejected') rejectedLeaves++;
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Admin Reports & Analytics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryCards(),
                  const SizedBox(height: 20),
                  _buildLineChart(),
                  const SizedBox(height: 20),
                  _buildDeptTable("Department-wise Complaints", complaintCount),
                  const SizedBox(height: 20),
                  _buildDeptTable("Department-wise Leave Requests", leaveCount),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _statCard("Complaints\nPending", pendingComplaints, Colors.orange),
        _statCard("Complaints\nSolved", solvedComplaints, Colors.green),
        _statCard("Complaints\nRejected", rejectedComplaints, Colors.red),
        _statCard("Leaves\nPending", pendingLeaves, Colors.orange),
        _statCard("Leaves\nApproved", approvedLeaves, Colors.green),
        _statCard("Leaves\nRejected", rejectedLeaves, Colors.red),
      ],
    );
  }

  Widget _statCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Department-wise Activity (Line Chart)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < departments.length) {
                          return Text(
                            departments[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text("");
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      departments.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        complaintCount[departments[index]]!.toDouble(),
                      ),
                    ),
                    isCurved: true,
                    color: Colors.deepPurple,
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: List.generate(
                      departments.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        leaveCount[departments[index]]!.toDouble(),
                      ),
                    ),
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 4,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.circle, size: 10, color: Colors.deepPurple),
              SizedBox(width: 4),
              Text("Complaints"),
              SizedBox(width: 20),
              Icon(Icons.circle, size: 10, color: Colors.orange),
              SizedBox(width: 4),
              Text("Leaves"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeptTable(String title, Map<String, int> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...data.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      e.value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  final List<String> departments = [
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'Cybersecurity',
    'IoT',
    'AIDS',
  ];

  Map<String, int> complaintCount = {};
  Map<String, int> leaveCount = {};

  List<QueryDocumentSnapshot> allComplaints = [];
  List<QueryDocumentSnapshot> allLeaves = [];

  int pendingComplaints = 0;
  int solvedComplaints = 0;
  int rejectedComplaints = 0;

  int pendingLeaves = 0;
  int approvedLeaves = 0;
  int rejectedLeaves = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    setState(() => isLoading = true);

    complaintCount.clear();
    leaveCount.clear();

    for (var dept in departments) {
      complaintCount[dept] = 0;
      leaveCount[dept] = 0;
    }

    final complaintsSnapshot =
        await FirebaseFirestore.instance.collection('complaints').get();

    final leavesSnapshot =
        await FirebaseFirestore.instance.collection('leave_requests').get();

    allComplaints = complaintsSnapshot.docs;
    allLeaves = leavesSnapshot.docs;

    pendingComplaints = 0;
    solvedComplaints = 0;
    rejectedComplaints = 0;

    pendingLeaves = 0;
    approvedLeaves = 0;
    rejectedLeaves = 0;

    for (var doc in complaintsSnapshot.docs) {
      final data = doc.data();
      final dept = data['department'];
      final status = data['status'] ?? 'Pending';

      if (complaintCount.containsKey(dept)) {
        complaintCount[dept] = complaintCount[dept]! + 1;
      }

      if (status == 'Pending') pendingComplaints++;
      if (status == 'Solved') solvedComplaints++;
      if (status == 'Rejected') rejectedComplaints++;
    }

    for (var doc in leavesSnapshot.docs) {
      final data = doc.data();
      final dept = data['department'];
      final status = data['status'] ?? 'Pending';

      if (leaveCount.containsKey(dept)) {
        leaveCount[dept] = leaveCount[dept]! + 1;
      }

      if (status == 'Pending') pendingLeaves++;
      if (status == 'Approved') approvedLeaves++;
      if (status == 'Rejected') rejectedLeaves++;
    }

    setState(() => isLoading = false);
  }

  void showDetails(List<QueryDocumentSnapshot> list, String status, bool isComplaint) {
    final filtered = list.where((doc) {
      final s = doc['status'] ?? 'Pending';
      return s == status;
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              isComplaint ? "Complaints - $status" : "Leave Requests - $status",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("No records found"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final data = filtered[i].data() as Map<String, dynamic>;
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(data['department'] ?? "-"),
                            ),
                            title: Text(data['name'] ?? "Student"),
                            subtitle: Text(data['reason'] ??
                                data['complaint'] ??
                                "No details"),
                            trailing: Text(
                              data['status'] ?? '',
                              style: TextStyle(
                                color: status == "Pending"
                                    ? Colors.orange
                                    : status == "Solved" || status == "Approved"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(String title, int count, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$count",
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 6),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildLineChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Department Activity",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < departments.length) {
                          return Text(departments[value.toInt()],
                              style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.deepPurple,
                    barWidth: 4,
                    spots: List.generate(
                      departments.length,
                      (i) => FlSpot(
                          i.toDouble(),
                          complaintCount[departments[i]]!.toDouble()),
                    ),
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 4,
                    spots: List.generate(
                      departments.length,
                      (i) => FlSpot(i.toDouble(),
                          leaveCount[departments[i]]!.toDouble()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              CircleAvatar(radius: 5, backgroundColor: Colors.deepPurple),
              SizedBox(width: 6),
              Text("Complaints"),
              SizedBox(width: 16),
              CircleAvatar(radius: 5, backgroundColor: Colors.orange),
              SizedBox(width: 6),
              Text("Leaves"),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Admin Reports"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Complaints Overview",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      statCard("Pending", pendingComplaints, Colors.orange,
                          () => showDetails(allComplaints, "Pending", true)),
                      statCard("Solved", solvedComplaints, Colors.green,
                          () => showDetails(allComplaints, "Solved", true)),
                      statCard("Rejected", rejectedComplaints, Colors.red,
                          () => showDetails(allComplaints, "Rejected", true)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Leave Requests Overview",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      statCard("Pending", pendingLeaves, Colors.orange,
                          () => showDetails(allLeaves, "Pending", false)),
                      statCard("Approved", approvedLeaves, Colors.green,
                          () => showDetails(allLeaves, "Approved", false)),
                      statCard("Rejected", rejectedLeaves, Colors.red,
                          () => showDetails(allLeaves, "Rejected", false)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildLineChart(),
                ],
              ),
            ),
    );
  }
}*/



/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  final List<String> departments = [
    'CSE',
    'IT',
    'ECE',
    'EEE',
    'Cybersecurity',
    'IoT',
    'AIDS',
  ];

  Map<String, int> complaintCount = {};
  Map<String, int> leaveCount = {};

  List<QueryDocumentSnapshot> allComplaints = [];
  List<QueryDocumentSnapshot> allLeaves = [];

  int pendingComplaints = 0;
  int solvedComplaints = 0;
  int rejectedComplaints = 0;

  int pendingLeaves = 0;
  int approvedLeaves = 0;
  int rejectedLeaves = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    setState(() => isLoading = true);

    complaintCount.clear();
    leaveCount.clear();

    for (var dept in departments) {
      complaintCount[dept] = 0;
      leaveCount[dept] = 0;
    }

    final complaintsSnapshot =
        await FirebaseFirestore.instance.collection('complaints').get();

    final leavesSnapshot =
        await FirebaseFirestore.instance.collection('leave_requests').get();

    allComplaints = complaintsSnapshot.docs;
    allLeaves = leavesSnapshot.docs;

    pendingComplaints = 0;
    solvedComplaints = 0;
    rejectedComplaints = 0;

    pendingLeaves = 0;
    approvedLeaves = 0;
    rejectedLeaves = 0;

    for (var doc in complaintsSnapshot.docs) {
      final data = doc.data();
      final dept = data['department'];
      final status = data['status'] ?? 'Pending';

      if (complaintCount.containsKey(dept)) {
        complaintCount[dept] = complaintCount[dept]! + 1;
      }

      if (status == 'Pending') pendingComplaints++;
      if (status == 'Solved') solvedComplaints++;
      if (status == 'Rejected') rejectedComplaints++;
    }

    for (var doc in leavesSnapshot.docs) {
      final data = doc.data();
      final dept = data['department'];
      final status = data['status'] ?? 'Pending';

      if (leaveCount.containsKey(dept)) {
        leaveCount[dept] = leaveCount[dept]! + 1;
      }

      if (status == 'Pending') pendingLeaves++;
      if (status == 'Approved') approvedLeaves++;
      if (status == 'Rejected') rejectedLeaves++;
    }

    setState(() => isLoading = false);
  }

  void showDetails(
      List<QueryDocumentSnapshot> list, String status, bool isComplaint) {
    final filtered = list.where((doc) {
      final s = doc['status'] ?? 'Pending';
      return s == status;
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              isComplaint ? "Complaints - $status" : "Leave Requests - $status",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("No records found"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final data = filtered[i].data() as Map<String, dynamic>;

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Text(data['department'] ?? "-"),
                            ),
                            title: Text(data['name'] ?? "Student"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isComplaint)
                                  Text("Complaint: ${data['complaint'] ?? ''}")
                                else ...[
                                  Text("Reason: ${data['reason'] ?? ''}"),
                                  Text(
                                      "From: ${data['fromDate']} → To: ${data['toDate']}"),
                                  Text(
                                      "Year ${data['year']} | Sec ${data['section']} | Roll ${data['rollNo']}"),
                                ],
                              ],
                            ),
                            trailing: Text(
                              data['status'] ?? '',
                              style: TextStyle(
                                color: status == "Pending"
                                    ? Colors.orange
                                    : status == "Solved" ||
                                            status == "Approved"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(String title, int count, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$count",
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 6),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 4),
            const Text("Tap to view",
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget buildLineChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Department Activity",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < departments.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              departments[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.deepPurple,
                    barWidth: 4,
                    spots: List.generate(
                      departments.length,
                      (i) => FlSpot(
                        i.toDouble(),
                        complaintCount[departments[i]]!.toDouble(),
                      ),
                    ),
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 4,
                    spots: List.generate(
                      departments.length,
                      (i) => FlSpot(
                        i.toDouble(),
                        leaveCount[departments[i]]!.toDouble(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Admin Reports"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Complaints Overview",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      statCard("Pending", pendingComplaints, Colors.orange,
                          () => showDetails(allComplaints, "Pending", true)),
                      statCard("Solved", solvedComplaints, Colors.green,
                          () => showDetails(allComplaints, "Solved", true)),
                      statCard("Rejected", rejectedComplaints, Colors.red,
                          () => showDetails(allComplaints, "Rejected", true)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Leave Requests Overview",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      statCard("Pending", pendingLeaves, Colors.orange,
                          () => showDetails(allLeaves, "Pending", false)),
                      statCard("Approved", approvedLeaves, Colors.green,
                          () => showDetails(allLeaves, "Approved", false)),
                      statCard("Rejected", rejectedLeaves, Colors.red,
                          () => showDetails(allLeaves, "Rejected", false)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildLineChart(),
                ],
              ),
            ),
    );
  }
}*/



/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {

  final List<String> departments = [
    'CSE','IT','ECE','EEE','Cybersecurity','IoT','AIDS'
  ];

  Map<String,int> complaintCount = {};
  Map<String,int> leaveCount = {};
  Map<String,int> monthlyComplaints = {};

  List<QueryDocumentSnapshot> allComplaints = [];
  List<QueryDocumentSnapshot> allLeaves = [];

  int pendingComplaints=0;
  int solvedComplaints=0;
  int rejectedComplaints=0;

  int pendingLeaves=0;
  int approvedLeaves=0;
  int rejectedLeaves=0;

  bool isLoading=true;

  final List<String> months=[
    "Jan","Feb","Mar","Apr","May","Jun",
    "Jul","Aug","Sep","Oct","Nov","Dec"
  ];

  @override
  void initState(){
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async{

    setState(()=>isLoading=true);

    complaintCount.clear();
    leaveCount.clear();
    monthlyComplaints.clear();

    for(var dept in departments){
      complaintCount[dept]=0;
      leaveCount[dept]=0;
    }

    for(int i=1;i<=12;i++){
      monthlyComplaints[i.toString()]=0;
    }

    final complaintsSnapshot =
        await FirebaseFirestore.instance.collection('complaints').get();

    final leavesSnapshot =
        await FirebaseFirestore.instance.collection('leave_requests').get();

    allComplaints = complaintsSnapshot.docs;
    allLeaves = leavesSnapshot.docs;

    pendingComplaints=0;
    solvedComplaints=0;
    rejectedComplaints=0;

    pendingLeaves=0;
    approvedLeaves=0;
    rejectedLeaves=0;

    for(var doc in complaintsSnapshot.docs){

      final data = doc.data() as Map<String,dynamic>;

      final dept = data['department'];
      final status = (data['status'] ?? 'Pending').toString().trim().toLowerCase();

      if(complaintCount.containsKey(dept)){
        complaintCount[dept] = complaintCount[dept]! + 1;
      }

      if(status=="pending") pendingComplaints++;
      if(status=="solved") solvedComplaints++;
      if(status=="rejected") rejectedComplaints++;

      if(data['timestamp']!=null){

        Timestamp ts=data['timestamp'];
        DateTime dt=ts.toDate();

        String monthKey=dt.month.toString();

        monthlyComplaints[monthKey]=monthlyComplaints[monthKey]!+1;
      }
    }

    for(var doc in leavesSnapshot.docs){

      final data = doc.data() as Map<String,dynamic>;

      final dept=data['department'];
      final status=(data['status'] ?? 'Pending').toString().trim().toLowerCase();

      if(leaveCount.containsKey(dept)){
        leaveCount[dept]=leaveCount[dept]!+1;
      }

      if(status=="pending") pendingLeaves++;
      if(status=="approved") approvedLeaves++;
      if(status=="rejected") rejectedLeaves++;
    }

    setState(()=>isLoading=false);
  }

  void showDetails(List<QueryDocumentSnapshot> list,String status,bool isComplaint){

    final filtered=list.where((doc){

      final data=doc.data() as Map<String,dynamic>;

      final s=(data['status'] ?? 'Pending')
          .toString()
          .trim()
          .toLowerCase();

      return s==status.toLowerCase();

    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled:true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_)=>Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:[

            Text(
              isComplaint
                  ? "Complaints - $status"
                  : "Leave Requests - $status",
              style: const TextStyle(fontSize:18,fontWeight:FontWeight.bold),
            ),

            const SizedBox(height:12),

            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("No records found"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder:(_,i){

                        final data=filtered[i].data() as Map<String,dynamic>;

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Text(
                                (data['department'] ?? "-")
                                    .toString()
                                    .substring(0,1),
                              ),
                            ),
                            title: Text(data['name'] ?? "Student"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                if(isComplaint)
                                  Text("Complaint: ${data['complaint'] ?? ''}")
                                else ...[
                                  Text("Reason: ${data['reason'] ?? ''}"),
                                  Text(
                                      "From: ${data['fromDate']} → ${data['toDate']}"),
                                  Text(
                                      "Year ${data['year']} | Sec ${data['section']} | Roll ${data['rollNo']}"),
                                ]
                              ],
                            ),
                            trailing: Text(
                              data['status'] ?? '',
                              style: TextStyle(
                                color: status=="Pending"
                                    ? Colors.orange
                                    : status=="Solved" || status=="Approved"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget statCard(String title,int count,Color color,VoidCallback onTap){

    return InkWell(
      onTap:onTap,
      child:Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:[color.withOpacity(0.7),color]),
          borderRadius: BorderRadius.circular(16),
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text("$count",
                style: const TextStyle(
                    fontSize:26,fontWeight:FontWeight.bold,color:Colors.white)),
            const SizedBox(height:6),
            Text(title,
                textAlign:TextAlign.center,
                style: const TextStyle(color:Colors.white)),
            const SizedBox(height:4),
            const Text("Tap to view",
                style: TextStyle(color:Colors.white70,fontSize:11)),
          ],
        ),
      ),
    );
  }

  Widget monthlyChart(){

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[

          const Text("Monthly Complaint Trend",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height:12),

          SizedBox(
            height:250,
            child:LineChart(
              LineChartData(
                gridData: FlGridData(show:true),
                borderData: FlBorderData(show:true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles:true,
                      getTitlesWidget:(value,meta){

                        int index=value.toInt();

                        if(index>=0 && index<12){
                          return Text(months[index],
                              style: const TextStyle(fontSize:10));
                        }
                        return const Text("");
                      },
                    ),
                  ),
                ),
                lineBarsData:[

                  LineChartBarData(
                    isCurved:true,
                    color:Colors.blue,
                    barWidth:4,
                    spots:List.generate(
                      12,
                      (i)=>FlSpot(
                        i.toDouble(),
                        monthlyComplaints[(i+1).toString()]!.toDouble(),
                      ),
                    ),
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget departmentRanking(){

    List<MapEntry<String,int>> sorted =
        complaintCount.entries.toList()
          ..sort((a,b)=>b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[

          const Text("Department Ranking (Complaints)",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height:12),

          ListView.builder(
            shrinkWrap:true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sorted.length,
            itemBuilder:(context,i){

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo.shade100,
                  child: Text("${i+1}"),
                ),
                title: Text(sorted[i].key),
                trailing: Text(
                  "${sorted[i].value}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Admin Reports"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),

      body:isLoading
          ? const Center(child:CircularProgressIndicator())
          :SingleChildScrollView(

              padding: const EdgeInsets.all(16),

              child:Column(
                children:[

                  const Text("Complaints Overview",
                      style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),

                  const SizedBox(height:10),

                  GridView.count(
                    crossAxisCount:3,
                    shrinkWrap:true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing:10,
                    mainAxisSpacing:10,
                    childAspectRatio: 1.4,
                    children:[

                      statCard("Pending",pendingComplaints,Colors.orange,
                          ()=>showDetails(allComplaints,"Pending",true)),

                      statCard("Solved",solvedComplaints,Colors.green,
                          ()=>showDetails(allComplaints,"Solved",true)),

                      statCard("Rejected",rejectedComplaints,Colors.red,
                          ()=>showDetails(allComplaints,"Rejected",true)),

                    ],
                  ),

                  const SizedBox(height:20),

                  const Text("Leave Requests Overview",
                      style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),

                  const SizedBox(height:10),

                  GridView.count(
                    crossAxisCount:3,
                    shrinkWrap:true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing:10,
                    mainAxisSpacing:10,
                    childAspectRatio: 1.4,
                    children:[

                      statCard("Pending",pendingLeaves,Colors.orange,
                          ()=>showDetails(allLeaves,"Pending",false)),

                      statCard("Approved",approvedLeaves,Colors.green,
                          ()=>showDetails(allLeaves,"Approved",false)),

                      statCard("Rejected",rejectedLeaves,Colors.red,
                          ()=>showDetails(allLeaves,"Rejected",false)),

                    ],
                  ),

                  const SizedBox(height:20),

                  monthlyChart(),

                  const SizedBox(height:20),

                  departmentRanking(),

                ],
              ),
            ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {

  final List<String> departments = [
    'CSE','IT','ECE','EEE','Cybersecurity','IoT','AIDS'
  ];

  Map<String,int> complaintCount = {};
  Map<String,int> leaveCount = {};
  Map<String,int> monthlyComplaints = {};

  List<QueryDocumentSnapshot> allComplaints = [];
  List<QueryDocumentSnapshot> allLeaves = [];

  int pendingComplaints=0;
  int solvedComplaints=0;
  int rejectedComplaints=0;

  int pendingLeaves=0;
  int approvedLeaves=0;
  int rejectedLeaves=0;

  bool isLoading=true;

  final List<String> months=[
    "Jan","Feb","Mar","Apr","May","Jun",
    "Jul","Aug","Sep","Oct","Nov","Dec"
  ];

  @override
  void initState(){
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async{

    setState(()=>isLoading=true);

    complaintCount.clear();
    leaveCount.clear();
    monthlyComplaints.clear();

    for(var dept in departments){
      complaintCount[dept]=0;
      leaveCount[dept]=0;
    }

    for(int i=1;i<=12;i++){
      monthlyComplaints[i.toString()]=0;
    }

    final complaintsSnapshot =
        await FirebaseFirestore.instance.collection('complaints').get();

    final leavesSnapshot =
        await FirebaseFirestore.instance.collection('leave_requests').get();

    allComplaints = complaintsSnapshot.docs;
    allLeaves = leavesSnapshot.docs;

    pendingComplaints=0;
    solvedComplaints=0;
    rejectedComplaints=0;

    pendingLeaves=0;
    approvedLeaves=0;
    rejectedLeaves=0;

    for(var doc in complaintsSnapshot.docs){

      final data = doc.data() as Map<String,dynamic>;

      final dept = data['department'];
      final status = (data['status'] ?? 'Pending').toString().trim().toLowerCase();

      if(complaintCount.containsKey(dept)){
        complaintCount[dept] = complaintCount[dept]! + 1;
      }

      if(status=="pending") pendingComplaints++;
      if(status=="solved") solvedComplaints++;
      if(status=="rejected") rejectedComplaints++;

      if(data['timestamp']!=null){

        Timestamp ts=data['timestamp'];
        DateTime dt=ts.toDate();

        String monthKey=dt.month.toString();

        monthlyComplaints[monthKey]=monthlyComplaints[monthKey]!+1;
      }
    }

    for(var doc in leavesSnapshot.docs){

      final data = doc.data() as Map<String,dynamic>;

      final dept=data['department'];
      final status=(data['status'] ?? 'Pending').toString().trim().toLowerCase();

      if(leaveCount.containsKey(dept)){
        leaveCount[dept]=leaveCount[dept]!+1;
      }

      if(status=="pending") pendingLeaves++;
      if(status=="approved") approvedLeaves++;
      if(status=="rejected") rejectedLeaves++;
    }

    setState(()=>isLoading=false);
  }

  void showDetails(List<QueryDocumentSnapshot> list,String status,bool isComplaint){

    final filtered=list.where((doc){

      final data=doc.data() as Map<String,dynamic>;

      final s=(data['status'] ?? 'Pending')
          .toString()
          .trim()
          .toLowerCase();

      return s==status.toLowerCase();

    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled:true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_)=>Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:[

            Text(
              isComplaint
                  ? "Complaints - $status"
                  : "Leave Requests - $status",
              style: const TextStyle(fontSize:18,fontWeight:FontWeight.bold),
            ),

            const SizedBox(height:12),

            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("No records found"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder:(_,i){

                        final data=filtered[i].data() as Map<String,dynamic>;

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Text(
                                (data['department'] ?? "-")
                                    .toString()
                                    .substring(0,1),
                              ),
                            ),
                            title: Text(data['name'] ?? "Student"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                if(isComplaint)
                                  Text("Complaint: ${data['complaint'] ?? ''}")
                                else ...[
                                  Text("Reason: ${data['reason'] ?? ''}"),
                                  Text(
                                      "From: ${data['fromDate']} → ${data['toDate']}"),
                                  Text(
                                      "Year ${data['year']} | Sec ${data['section']} | Roll ${data['rollNo']}"),
                                ]
                              ],
                            ),
                            trailing: Text(
                              data['status'] ?? '',
                              style: TextStyle(
                                color: status=="Pending"
                                    ? Colors.orange
                                    : status=="Solved" || status=="Approved"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget statCard(String title,int count,Color color,VoidCallback onTap){

    return InkWell(
      onTap:onTap,
      child:Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:[color.withOpacity(0.7),color]),
          borderRadius: BorderRadius.circular(16),
        ),
        child:FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text("$count",
                style: const TextStyle(
                    fontSize:26,fontWeight:FontWeight.bold,color:Colors.white)),
            const SizedBox(height:6),
            Text(title,
                textAlign:TextAlign.center,
                style: const TextStyle(color:Colors.white)),
            const SizedBox(height:4),
            const Text("Tap to view",
                style: TextStyle(color:Colors.white70,fontSize:11)),
          ],
        ),
      ),
    ));
  }

  Widget monthlyChart(){

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[

          const Text("Monthly Complaint Trend",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height:12),

          SizedBox(
            height:250,
            child:LineChart(
              LineChartData(
                gridData: FlGridData(show:true),
                borderData: FlBorderData(show:true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles:true,
                      getTitlesWidget:(value,meta){

                        int index=value.toInt();

                        if(index>=0 && index<12){
                          return Text(months[index],
                              style: const TextStyle(fontSize:10));
                        }
                        return const Text("");
                      },
                    ),
                  ),
                ),
                lineBarsData:[

                  LineChartBarData(
                    isCurved:true,
                    color:Colors.blue,
                    barWidth:4,
                    spots:List.generate(
                      12,
                      (i)=>FlSpot(
                        i.toDouble(),
                        monthlyComplaints[(i+1).toString()]!.toDouble(),
                      ),
                    ),
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget departmentRanking(){

    List<MapEntry<String,int>> sorted =
        complaintCount.entries.toList()
          ..sort((a,b)=>b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[

          const Text("Department Ranking (Complaints)",
              style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height:12),

          ListView.builder(
            shrinkWrap:true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sorted.length,
            itemBuilder:(context,i){

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo.shade100,
                  child: Text("${i+1}"),
                ),
                title: Text(sorted[i].key),
                trailing: Text(
                  "${sorted[i].value}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Admin Reports"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),

      body:isLoading
          ? const Center(child:CircularProgressIndicator())
          :SingleChildScrollView(

              padding: const EdgeInsets.all(16),

              child:Column(
                children:[

                  const Text("Complaints Overview",
                      style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),

                  const SizedBox(height:10),

                  GridView.count(
                    crossAxisCount:3,
                    shrinkWrap:true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing:10,
                    mainAxisSpacing:10,
                    childAspectRatio: 1.4,
                    children:[

                      statCard("Pending",pendingComplaints,Colors.orange,
                          ()=>showDetails(allComplaints,"Pending",true)),

                      statCard("Solved",solvedComplaints,Colors.green,
                          ()=>showDetails(allComplaints,"Solved",true)),

                      statCard("Rejected",rejectedComplaints,Colors.red,
                          ()=>showDetails(allComplaints,"Rejected",true)),

                    ],
                  ),

                  const SizedBox(height:20),

                  const Text("Leave Requests Overview",
                      style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),

                  const SizedBox(height:10),

                  GridView.count(
                    crossAxisCount:3,
                    shrinkWrap:true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing:10,
                    mainAxisSpacing:10,
                    childAspectRatio: 1.4,
                    children:[

                      statCard("Pending",pendingLeaves,Colors.orange,
                          ()=>showDetails(allLeaves,"Pending",false)),

                      statCard("Approved",approvedLeaves,Colors.green,
                          ()=>showDetails(allLeaves,"Approved",false)),

                      statCard("Rejected",rejectedLeaves,Colors.red,
                          ()=>showDetails(allLeaves,"Rejected",false)),

                    ],
                  ),

                  const SizedBox(height:20),

                  monthlyChart(),

                  const SizedBox(height:20),

                  departmentRanking(),

                ],
              ),
            ),
    );
  }
}
