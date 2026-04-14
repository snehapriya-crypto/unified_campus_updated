/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeBoardScreen extends StatefulWidget {
  final String studentYear;    // e.g., "2"
  final String studentSection; // e.g., "A"

  const NoticeBoardScreen({
    super.key,
    required this.studentYear,
    required this.studentSection,
  });

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notice Board")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notices')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notices = snapshot.data!.docs;

          // Filter notices based on student year/section
          final studentNotices = notices.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final allCollege = data['allCollege'] ?? false;
            final years = List<String>.from(data['year'] ?? []);
            final sections = List<String>.from(data['section'] ?? []);

            return allCollege ||
                (years.contains(widget.studentYear) &&
                    sections.contains(widget.studentSection));
          }).toList();

          if (studentNotices.isEmpty) {
            return const Center(child: Text("No notices available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: studentNotices.length,
            itemBuilder: (context, index) {
              final data =
                  studentNotices[index].data() as Map<String, dynamic>;

              final attachments =
                  List<String>.from(data['attachments'] ?? []);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? "No Title",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(data['description'] ?? "No Description"),
                      const SizedBox(height: 6),
                      if (attachments.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Attachments:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            ...attachments.map(
                              (url) => GestureDetector(
                                onTap: () async {
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    launchUrl(Uri.parse(url));
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    url.split('/').last,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      const SizedBox(height: 6),
                      Text(
                        "Posted By: ${data['postedBy'] ?? 'Staff'}",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12),
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


class NoticeBoardScreen extends StatelessWidget {
  const NoticeBoardScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notice Board")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notices')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Something went wrong"));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final notices = snapshot.data!.docs;

          if (notices.isEmpty) return const Center(child: Text("No notices available"));

          return ListView.builder(
            itemCount: notices.length,
            itemBuilder: (context, index) {
              final data = notices[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(data['description'] ?? ''),
                      if (data['attachments'] != null && (data['attachments'] as List).isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            const Text("Attachments:"),
                            ...List<Widget>.from((data['attachments'] as List).map((link) {
                              return InkWell(
                                onTap: () => _openLink(link.toString()),
                                child: Text(link.toString().split('/').last, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                              );
                            })),
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
import 'package:firebase_auth/firebase_auth.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  String? studentDept;
  String? studentYear;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        studentDept = doc['department'];
        studentYear = doc['year'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notice Board"),
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notices')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notices = snapshot.data!.docs;

                final filteredNotices = notices.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final noticeDept = data['department'];
                  final List noticeYears = data['years'];

                  bool deptMatch =
                      noticeDept == 'All' || noticeDept == studentDept;

                  bool yearMatch =
                      noticeYears.contains('All') ||
                          noticeYears.contains(studentYear);

                  return deptMatch && yearMatch;
                }).toList();

                if (filteredNotices.isEmpty) {
                  return const Center(child: Text("No notices for you"));
                }

                return ListView.builder(
                  itemCount: filteredNotices.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredNotices[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Title
                            Text(
                              data['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // 🔹 Description
                            Text(data['description'] ?? ''),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Dept: ${data['department']}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "Years: ${(data['years'] as List).join(', ')}",
                                  style: const TextStyle(fontSize: 12),
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
import 'package:firebase_auth/firebase_auth.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  String? studentDept;
  String? studentYear;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        studentDept = doc['department'];
        studentYear = doc['year'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  String formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text("Notice Board"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notices')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notices = snapshot.data!.docs;

                final filteredNotices = notices.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final noticeDept = data['department'];
                  final List noticeYears = data['years'];

                  bool deptMatch =
                      noticeDept == 'All' || noticeDept == studentDept;

                  bool yearMatch = noticeYears.contains('All') ||
                      noticeYears.contains(studentYear);

                  return deptMatch && yearMatch;
                }).toList();

                if (filteredNotices.isEmpty) {
                  return const Center(
                    child: Text("No notices for your department/year"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredNotices.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredNotices[index].data() as Map<String, dynamic>;

                    final Timestamp? timeStamp = data['timestamp'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A5AE0), Color(0xFF7F9CF5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  child: Icon(Icons.notifications,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    data['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              data['description'] ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 12),

                            Wrap(
                              spacing: 6,
                              children: [
                                _chip("Dept: ${data['department']}"),
                                _chip(
                                  "Years: ${(data['years'] as List).join(', ')}",
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                timeStamp != null
                                    ? formatTime(timeStamp)
                                    : '',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
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

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.indigo,
        ),
      ),
    );
  }
}
