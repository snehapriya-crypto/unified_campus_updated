/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StaffPostNoticeScreen extends StatefulWidget {
  const StaffPostNoticeScreen({super.key});

  @override
  State<StaffPostNoticeScreen> createState() => _StaffPostNoticeScreenState();
}

class _StaffPostNoticeScreenState extends State<StaffPostNoticeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  List<String> selectedYears = [];
  List<String> selectedSections = [];
  bool allCollege = false;

  List<PlatformFile> attachments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Notice")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: "Notice Title", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),

            // Description
            TextField(
              controller: descController,
              maxLines: 6,
              decoration: const InputDecoration(
                  labelText: "Notice Description",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),

            // Filters
            const Text("Select Year(s):"),
            Wrap(
              spacing: 10,
              children: ["1", "2", "3", "4"].map((year) {
                return FilterChip(
                  label: Text(year),
                  selected: selectedYears.contains(year),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        selectedYears.add(year);
                      } else {
                        selectedYears.remove(year);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            const Text("Select Section(s):"),
            Wrap(
              spacing: 10,
              children: ["A", "B", "C", "D"].map((sec) {
                return FilterChip(
                  label: Text(sec),
                  selected: selectedSections.contains(sec),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        selectedSections.add(sec);
                      } else {
                        selectedSections.remove(sec);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Checkbox(
                  value: allCollege,
                  onChanged: (val) {
                    setState(() {
                      allCollege = val!;
                      if (allCollege) {
                        selectedYears.clear();
                        selectedSections.clear();
                      }
                    });
                  },
                ),
                const Text("All College"),
              ],
            ),

            const SizedBox(height: 12),

            // Attachments
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                if (result != null) {
                  setState(() {
                    attachments = result.files;
                  });
                }
              },
              child: const Text("Pick PDF / Images"),
            ),
            if (attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Selected: ${attachments.map((e) => e.name).join(", ")}",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),

            const SizedBox(height: 20),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        descController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill Title and Description")));
                      return;
                    }

                    // Upload attachments to Firebase Storage
                    List<String> attachmentUrls = [];
                    for (var file in attachments) {
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child('notices/${file.name}');
                      await ref.putData(file.bytes!);
                      String url = await ref.getDownloadURL();
                      attachmentUrls.add(url);
                    }

                    // Save notice to Firestore
                    await FirebaseFirestore.instance.collection('notices').add({
                      'title': titleController.text.trim(),
                      'description': descController.text.trim(),
                      'attachments': attachmentUrls,
                      'year': selectedYears,
                      'section': selectedSections,
                      'allCollege': allCollege,
                      'postedBy': "Staff Name",
                      'timestamp': Timestamp.now(),
                    });

                    titleController.clear();
                    descController.clear();
                    attachments.clear();
                    selectedYears.clear();
                    selectedSections.clear();
                    allCollege = false;

                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Notice Posted ✅")));
                  },
                  child: const Text("Post Notice")),
            ),
          ],
        ),
      ),
    );
  }
}*/


/*import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StaffPostNoticeScreen extends StatefulWidget {
  const StaffPostNoticeScreen({super.key});

  @override
  State<StaffPostNoticeScreen> createState() => _StaffPostNoticeScreenState();
}

class _StaffPostNoticeScreenState extends State<StaffPostNoticeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  List<String> selectedYears = [];
  List<String> selectedSections = [];
  bool allCollege = false;

  FilePickerResult? pickedFiles;

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      withData: true, // VERY IMPORTANT
    );

    if (result != null) {
      setState(() {
        pickedFiles = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Notice")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Notice Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            /// Description
            TextField(
              controller: descController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Notice Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Year filter
            const Text("Select Year(s):"),
            Wrap(
              spacing: 10,
              children: ["1", "2", "3", "4"].map((year) {
                return FilterChip(
                  label: Text(year),
                  selected: selectedYears.contains(year),
                  onSelected: (val) {
                    setState(() {
                      val ? selectedYears.add(year) : selectedYears.remove(year);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            /// Section filter
            const Text("Select Section(s):"),
            Wrap(
              spacing: 10,
              children: ["A", "B", "C", "D"].map((sec) {
                return FilterChip(
                  label: Text(sec),
                  selected: selectedSections.contains(sec),
                  onSelected: (val) {
                    setState(() {
                      val
                          ? selectedSections.add(sec)
                          : selectedSections.remove(sec);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            /// All college
            Row(
              children: [
                Checkbox(
                  value: allCollege,
                  onChanged: (val) {
                    setState(() {
                      allCollege = val!;
                      if (allCollege) {
                        selectedYears.clear();
                        selectedSections.clear();
                      }
                    });
                  },
                ),
                const Text("All College"),
              ],
            ),

            const SizedBox(height: 16),

            /// File picker
            ElevatedButton.icon(
              onPressed: pickFiles,
              icon: const Icon(Icons.attach_file),
              label: const Text("Attach PDF / Image"),
            ),

            if (pickedFiles != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pickedFiles!.files
                      .map((f) => Text("• ${f.name}"))
                      .toList(),
                ),
              ),

            const SizedBox(height: 20),

            /// Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Post Notice"),
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      descController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Fill title and description")),
                    );
                    return;
                  }

                  List<String> attachmentUrls = [];

                  if (pickedFiles != null) {
                    for (var file in pickedFiles!.files) {
                      Uint8List? bytes = file.bytes;
                      if (bytes == null) continue;

                      final ref = FirebaseStorage.instance
                          .ref('notices/${DateTime.now().millisecondsSinceEpoch}_${file.name}');

                      await ref.putData(bytes);
                      final url = await ref.getDownloadURL();
                      attachmentUrls.add(url);
                    }
                  }

                  await FirebaseFirestore.instance.collection('notices').add({
                    'title': titleController.text.trim(),
                    'description': descController.text.trim(),
                    'attachments': attachmentUrls,
                    'years': selectedYears,
                    'sections': selectedSections,
                    'allCollege': allCollege,
                    'postedBy': 'Staff',
                    'timestamp': Timestamp.now(),
                  });

                  titleController.clear();
                  descController.clear();
                  pickedFiles = null;
                  selectedYears.clear();
                  selectedSections.clear();
                  allCollege = false;

                  setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Notice Posted ✅")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/


/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StaffPostNoticeScreen extends StatefulWidget {
  const StaffPostNoticeScreen({super.key});

  @override
  State<StaffPostNoticeScreen> createState() =>
      _StaffPostNoticeScreenState();
}

class _StaffPostNoticeScreenState extends State<StaffPostNoticeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  List<PlatformFile> attachments = [];
  bool isUploading = false;

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      withData: true, // IMPORTANT for WEB
    );

    if (result != null) {
      setState(() {
        attachments = result.files;
      });
    }
  }

  Future<void> postNotice() async {
    if (titleController.text.isEmpty ||
        descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => isUploading = true);

    List<String> fileUrls = [];

    for (final file in attachments) {
      final ref = FirebaseStorage.instance
          .ref("notices/${DateTime.now().millisecondsSinceEpoch}_${file.name}");

      await ref.putData(file.bytes!);
      final url = await ref.getDownloadURL();
      fileUrls.add(url);
    }

    await FirebaseFirestore.instance.collection("notices").add({
      "title": titleController.text.trim(),
      "description": descController.text.trim(),
      "files": fileUrls,
      "postedBy": "Staff",
      "createdAt": Timestamp.now(),
    });

    titleController.clear();
    descController.clear();
    attachments.clear();

    setState(() => isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notice Posted ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Notice")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Notice Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Notice Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: pickFiles,
              child: const Text("Pick PDF / Image"),
            ),

            if (attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  attachments.map((e) => e.name).join(", "),
                  style: const TextStyle(fontSize: 12),
                ),
              ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: isUploading ? null : postNotice,
              child: isUploading
                  ? const CircularProgressIndicator()
                  : const Text("Post Notice"),
            ),
          ],
        ),
      ),
    );
  }
}*/





/*import 'dart:io'; // Only for Mobile
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StaffPostNoticeScreen extends StatefulWidget {
  const StaffPostNoticeScreen({super.key});

  @override
  State<StaffPostNoticeScreen> createState() => _StaffPostNoticeScreenState();
}

class _StaffPostNoticeScreenState extends State<StaffPostNoticeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  List<PlatformFile> attachments = [];
  bool isUploading = false;

  // Pick files
  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      withData: true, // IMPORTANT for WEB
    );

    if (result != null) {
      setState(() {
        attachments = result.files;
      });
    }
  }

  // Post notice
  Future<void> postNotice() async {
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => isUploading = true);

    List<String> fileUrls = [];

    try {
      for (final file in attachments) {
        final ref = FirebaseStorage.instance
            .ref("notices/${DateTime.now().millisecondsSinceEpoch}_${file.name}");

        if (kIsWeb) {
          // Web
          await ref.putData(file.bytes!);
        } else {
          // Mobile
          await ref.putFile(File(file.path!));
        }

        final url = await ref.getDownloadURL();
        fileUrls.add(url);
      }

      await FirebaseFirestore.instance.collection("notices").add({
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
        "files": fileUrls,
        "postedBy": "Staff",
        "createdAt": Timestamp.now(),
      });

      titleController.clear();
      descController.clear();
      attachments.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notice Posted ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Notice")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Notice Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Notice Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: pickFiles,
              child: const Text("Pick PDF / Image"),
            ),
            if (attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  attachments.map((e) => e.name).join(", "),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isUploading ? null : postNotice,
              child: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Post Notice"),
            ),
          ],
        ),
      ),
    );
  }
}*/




/*import 'dart:io'; // Only for Mobile
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StaffPostNoticeScreen extends StatefulWidget {
  const StaffPostNoticeScreen({super.key});

  @override
  State<StaffPostNoticeScreen> createState() => _StaffPostNoticeScreenState();
}

class _StaffPostNoticeScreenState extends State<StaffPostNoticeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  List<PlatformFile> attachments = [];
  bool isUploading = false;

  // Pick files
  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      withData: kIsWeb, // only required for web
    );

    if (result != null) {
      setState(() {
        attachments = result.files;
      });
    }
  }

  // Upload a single file and return URL
  Future<String> uploadFile(PlatformFile file) async {
    final storageRef = FirebaseStorage.instance
        .ref("notices/${DateTime.now().millisecondsSinceEpoch}_${file.name}");

    if (kIsWeb) {
      if (file.bytes == null) {
        throw Exception("File data is empty for ${file.name}");
      }
      final task = await storageRef.putData(file.bytes!);
      return await storageRef.getDownloadURL();
    } else {
      if (file.path == null) {
        throw Exception("File path is null for ${file.name}");
      }
      final task = await storageRef.putFile(File(file.path!));
      return await storageRef.getDownloadURL();
    }
  }

  // Post notice
 Future<void> postNotice() async {
  if (titleController.text.isEmpty || descController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fill all fields")),
    );
    return;
  }

  if (attachments.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pick at least one file")),
    );
    return;
  }

  setState(() => isUploading = true);

  List<String> fileUrls = [];

  try {
    for (final file in attachments) {
      final ref = FirebaseStorage.instance
          .ref("notices/${DateTime.now().millisecondsSinceEpoch}_${file.name}");

      if (kIsWeb) {
        // Make sure bytes are not null
        if (file.bytes == null) {
          throw "File data is empty!";
        }
        await ref.putData(file.bytes!);
      } else {
        if (file.path == null) {
          throw "File path is empty!";
        }
        await ref.putFile(File(file.path!));
      }

      final url = await ref.getDownloadURL();
      fileUrls.add(url);
    }

    await FirebaseFirestore.instance.collection("notices").add({
      "title": titleController.text.trim(),
      "description": descController.text.trim(),
      "files": fileUrls,
      "postedBy": "Staff",
      "createdAt": Timestamp.now(),
    });

    titleController.clear();
    descController.clear();
    attachments.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notice Posted ✅")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() => isUploading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Notice")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Notice Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Notice Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: pickFiles,
              child: const Text("Pick PDF / Image"),
            ),
            if (attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  attachments.map((e) => e.name).join(", "),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isUploading ? null : postNotice,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
              ),
              child: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Post Notice"),
            ),
          ],
        ),
      ),
    );
  }
}*/


import 'dart:io'; // For mobile
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StaffPostNoticeScreen extends StatefulWidget {
  const StaffPostNoticeScreen({super.key});

  @override
  State<StaffPostNoticeScreen> createState() => _StaffPostNoticeScreenState();
}

class _StaffPostNoticeScreenState extends State<StaffPostNoticeScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  // Department
  String selectedDept = 'IT';
  final List<String> departments = [
    'IT',
    'CSE',
    'ECE',
    'EEE',
    'IoT',
    'AIDS',
    'Cybersecurity',
    'All',
  ];

  // Year filter
  final List<String> years = ['1', '2', '3', '4'];
  List<String> selectedYears = [];
  bool allYearsSelected = false;

  // Files
  List<PlatformFile> attachments = [];
  bool isUploading = false;

  // Pick files
  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        attachments = result.files;
      });
    }
  }

  // Post notice
  Future<void> postNotice() async {
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    if (!allYearsSelected && selectedYears.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select at least one year")),
      );
      return;
    }

    setState(() => isUploading = true);

    List<String> fileUrls = [];

    try {
      for (final file in attachments) {
        final ref = FirebaseStorage.instance
            .ref("notices/${DateTime.now().millisecondsSinceEpoch}_${file.name}");

        if (kIsWeb) {
          if (file.bytes == null) throw "File bytes missing!";
          await ref.putData(file.bytes!);
        } else {
          if (file.path == null) throw "File path missing!";
          await ref.putFile(File(file.path!));
        }

        final url = await ref.getDownloadURL();
        fileUrls.add(url);
      }

      await FirebaseFirestore.instance.collection("notices").add({
        "title": titleController.text.trim(),
        "description": descController.text.trim(),
        "attachments": fileUrls,
        "department": selectedDept,
        "years": allYearsSelected ? ['All'] : selectedYears,
        "postedByRole": "staff",
        "timestamp": FieldValue.serverTimestamp(),
      });

      titleController.clear();
      descController.clear();

      setState(() {
        attachments.clear();
        selectedDept = 'IT';
        selectedYears.clear();
        allYearsSelected = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notice Posted Successfully ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Post Notice"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Notice Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // Description
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Notice Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // Pick Files
            ElevatedButton.icon(
              onPressed: pickFiles,
              icon: const Icon(Icons.upload_file),
              label: const Text("Pick PDF / Image"),
            ),

            if (attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  attachments.map((e) => e.name).join(", "),
                  style: const TextStyle(fontSize: 12),
                ),
              ),

            const SizedBox(height: 16),

            // Department Dropdown
            DropdownButtonFormField<String>(
              value: selectedDept,
              decoration: const InputDecoration(
                labelText: "Select Department",
                border: OutlineInputBorder(),
              ),
              items: departments
                  .map((dept) => DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDept = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            const Text(
              "Select Years",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Wrap(
              spacing: 8,
              children: [
                ...years.map((year) {
                  return FilterChip(
                    label: Text("Year $year"),
                    selected: selectedYears.contains(year),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedYears.add(year);
                          allYearsSelected = false;
                        } else {
                          selectedYears.remove(year);
                        }
                      });
                    },
                  );
                }),
                FilterChip(
                  label: const Text("All Years"),
                  selected: allYearsSelected,
                  onSelected: (selected) {
                    setState(() {
                      allYearsSelected = selected;
                      if (selected) selectedYears.clear();
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isUploading ? null : postNotice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                child: isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "POST NOTICE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


