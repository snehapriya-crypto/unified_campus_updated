/*import 'package:flutter/material.dart';
import 'staff_complaints.dart';
import 'staff_leave.dart';
import 'staff_lab.dart';
import 'staff_event.dart';
import 'staff_hostel.dart';
import 'staff_post_notice.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 👤 Profile Section
            Card(
              color: Colors.deepPurple.shade50,
              child: const ListTile(
                leading: Icon(
                  Icons.person_pin,
                  size: 50,
                  color: Colors.deepPurple,
                ),
                title: Text(
                  "Staff Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text("Role: Staff"),
              ),
            ),

            const SizedBox(height: 20),

            // 📦 Dashboard Modules
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  dashboardCard(context, Icons.bookmark_added, "Approve Leave"),
                  dashboardCard(context, Icons.report, "View Complaints"),
                  dashboardCard(context, Icons.science, "Lab Approval"),
                  dashboardCard(context, Icons.event_available, "Event Handling"),
                  dashboardCard(context, Icons.home_work, "Hostel Requests"),
                  dashboardCard(context, Icons.notifications_active, "Post Notice"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(BuildContext context, IconData icon, String title) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (title == "Approve Leave") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StaffLeaveScreen(),
              ),
            );
          } 
          else if (title == "View Complaints") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StaffComplaints(),
              ),
            );
          } 
          else if (title == "Lab Approval") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StaffLabScreen(),
              ),
            );
          } 
          else if (title == "Event Handling") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StaffEventScreen(),
              ),
            );
          } 
          else if (title == "Hostel Requests") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StaffHostelScreen(),
              ),
            );
          } 
          else if (title == "Post Notice") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StaffPostNoticeScreen(),
              ),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'staff_complaints.dart';
import 'staff_leave.dart';
import 'staff_lab.dart';
import 'staff_event.dart';
import 'staff_hostel.dart';
import 'staff_post_notice.dart';

class StaffDashboard extends StatelessWidget {
  const StaffDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔷 Modern AppBar
      appBar: AppBar(
        title: const Text(
          "Staff Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // 👤 Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8360c3), Color(0xFF2ebf91)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35, color: Colors.deepPurple),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Staff Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Role: Staff",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 📦 Dashboard Modules
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  dashboardCard(context, Icons.bookmark_added, "Approve Leave", Colors.green),
                  dashboardCard(context, Icons.report, "View Complaints", Colors.redAccent),
                  dashboardCard(context, Icons.science, "Lab Approval", Colors.blue),
                  dashboardCard(context, Icons.event_available, "Event Handling", Colors.orange),
                  dashboardCard(context, Icons.home_work, "Hostel Requests", Colors.purple),
                  dashboardCard(context, Icons.notifications_active, "Post Notice", Colors.teal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(BuildContext context, IconData icon, String title, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if (title == "Approve Leave") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffLeaveScreen()));
        } 
        else if (title == "View Complaints") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffComplaints()));
        } 
        else if (title == "Lab Approval") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffLabScreen()));
        } 
        else if (title == "Event Handling") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffEventScreen()));
        } 
        else if (title == "Hostel Requests") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffHostelScreen()));
        } 
        else if (title == "Post Notice") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffPostNoticeScreen()));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_complaints.dart';
import 'staff_leave.dart';
import 'staff_lab.dart';
import 'staff_event.dart';
import 'staff_hostel.dart';
import 'staff_post_notice.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {

  @override
  void initState() {
    super.initState();
    checkHighPriorityComplaint();
  }

  // 🔴 Check for High Priority Complaints
  void checkHighPriorityComplaint() async {

    final query = await FirebaseFirestore.instance
        .collection('complaints')
        .where('priority', isEqualTo: 'High')
        .where('status', isEqualTo: 'Pending')
        .get();

    if (query.docs.isNotEmpty) {

      final data = query.docs.first.data();

      Future.delayed(const Duration(seconds: 1), () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("🚨 High Priority Complaint"),
              content: Text(data['complaint'] ?? "Urgent issue reported"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Later"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffComplaints(),
                      ),
                    );
                  },
                  child: const Text("View Now"),
                )
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          "Staff Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // 👤 Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8360c3), Color(0xFF2ebf91)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35, color: Colors.deepPurple),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Staff Name",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Role: Staff",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [

                  dashboardCard(context, Icons.bookmark_added, "Approve Leave", Colors.green),

                  dashboardCard(context, Icons.report, "View Complaints", Colors.redAccent),

                  dashboardCard(context, Icons.science, "Lab Approval", Colors.blue),

                  dashboardCard(context, Icons.event_available, "Event Handling", Colors.orange),

                  dashboardCard(context, Icons.home_work, "Hostel Requests", Colors.purple),

                  dashboardCard(context, Icons.notifications_active, "Post Notice", Colors.teal),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(BuildContext context, IconData icon, String title, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {

        if (title == "Approve Leave") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffLeaveScreen()));
        }

        else if (title == "View Complaints") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffComplaints()));
        }

        else if (title == "Lab Approval") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffLabScreen()));
        }

        else if (title == "Event Handling") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffEventScreen()));
        }

        else if (title == "Hostel Requests") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffHostelScreen()));
        }

        else if (title == "Post Notice") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffPostNoticeScreen()));
        }
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 30, color: color),
            ),

            const SizedBox(height: 15),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),

          ],
        ),
      ),
    );
  }
}



