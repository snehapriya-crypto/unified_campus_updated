/*import 'package:flutter/material.dart';

import 'student_complaint_screen.dart';
import 'leave_request_screen.dart';
import 'lab_booking_screen.dart';
import 'event_registration_screen.dart';
import 'hostel_request_screen.dart';
import 'notice_board_screen.dart';





class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            Card(
              color: Colors.blue[50],
              child: const ListTile(
                leading: Icon(Icons.person, size: 50, color: Colors.blue),
                title: Text(
                  "Student Name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Role: Student"),
              ),
            ),

            const SizedBox(height: 20),

            // Dashboard Modules
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  dashboardCard(
                    context,
                    Icons.report_problem,
                    "Complaints",
                    const StudentComplaintScreen(),
                  ),
                  dashboardCard(
                    context,
                    Icons.calendar_today,
                    "Leave Request",
                    const LeaveRequestScreen(),
                  ),
                  dashboardCard(
                    context,
                    Icons.science,
                    "Lab Booking",
                    const LabBookingScreen(),
                  ),
                  dashboardCard(
                    context,
                    Icons.event,
                    "Event Registration",
                    const EventRegistrationScreen(),
                  ),
                  dashboardCard(
                    context,
                    Icons.hotel,
                    "Hostel Request",
                    const HostelRequestScreen(),
                  ),
                  dashboardCard(
                    context,
                    Icons.notifications,
                    "Notice Board",
                    const NoticeBoardScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget dashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.blue),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';

import 'student_complaint_screen.dart';
import 'leave_request_screen.dart';
import 'lab_booking_screen.dart';
import 'event_registration_screen.dart';
import 'hostel_request_screen.dart';
import 'notice_board_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      // 🔵 Gradient AppBar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Student Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔷 Profile Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const ListTile(
                contentPadding: EdgeInsets.all(18),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Colors.blue),
                ),
                title: Text(
                  "Student Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Role: Student",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔷 Modules Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [

                  // 🔴 Complaints
                  dashboardCard(
                    context,
                    Icons.report_problem,
                    "Complaints",
                    const StudentComplaintScreen(),
                    Colors.red,
                    Colors.redAccent,
                  ),

                  // 🟢 Leave
                  dashboardCard(
                    context,
                    Icons.calendar_today,
                    "Leave Request",
                    const LeaveRequestScreen(),
                    Colors.green,
                    Colors.lightGreen,
                  ),

                  // 🟣 Lab
                  dashboardCard(
                    context,
                    Icons.science,
                    "Lab Booking",
                    const LabBookingScreen(),
                    Colors.purple,
                    Colors.deepPurpleAccent,
                  ),

                  // 🟠 Event
                  dashboardCard(
                    context,
                    Icons.event,
                    "Event Registration",
                    const EventRegistrationScreen(),
                    Colors.orange,
                    Colors.deepOrangeAccent,
                  ),

                  // 🟡 Hostel
                  dashboardCard(
                    context,
                    Icons.hotel,
                    "Hostel Request",
                    const HostelRequestScreen(),
                    Colors.amber,
                    Colors.orangeAccent,
                  ),

                  // 🔵 Notice
                  dashboardCard(
                    context,
                    Icons.notifications,
                    "Notice Board",
                    const NoticeBoardScreen(),
                    Colors.blue,
                    Colors.lightBlueAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🌈 Colorful Gradient Card
  static Widget dashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
    Color startColor,
    Color endColor,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: startColor.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/



import 'package:flutter/material.dart';

import 'student_complaint_screen.dart';
import 'leave_request_screen.dart';
import 'lab_booking_screen.dart';
import 'event_registration_screen.dart';
import 'hostel_request_screen.dart';
import 'notice_board_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // Simple AppBar
      appBar: AppBar(
        title: const Text(
          "Student Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Profile Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.person, size: 30, color: Colors.blue),
                ),
                title: Text(
                  "Student Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text("Role: Student"),
              ),
            ),

            const SizedBox(height: 25),

            // Modules Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [

                  dashboardCard(
                    context,
                    Icons.report_problem,
                    "Complaints",
                    const StudentComplaintScreen(),
                    Colors.red,
                  ),

                  dashboardCard(
                    context,
                    Icons.calendar_today,
                    "Leave Request",
                    const LeaveRequestScreen(),
                    Colors.green,
                  ),

                  dashboardCard(
                    context,
                    Icons.science,
                    "Lab Booking",
                    const LabBookingScreen(),
                    Colors.purple,
                  ),

                  dashboardCard(
                    context,
                    Icons.event,
                    "Event Registration",
                    const EventRegistrationScreen(),
                    Colors.orange,
                  ),

                  dashboardCard(
                    context,
                    Icons.hotel,
                    "Hostel Request",
                    const HostelRequestScreen(),
                    Colors.teal,
                  ),

                  dashboardCard(
                    context,
                    Icons.notifications,
                    "Notice Board",
                    const NoticeBoardScreen(),
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget dashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
    Color iconColor,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



