import 'package:examai/views/Dashboard/student_dashboard/dashboard.dart';
import 'package:examai/views/Dashboard/student_dashboard/sidebar.dart';
import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    Dashboard(),
    const Center(child: Text("My Courses Content")),
    const Center(child: Text("Exams Content")),
    const Center(child: Text("Timetable Content")),
    const Center(child: Text("Results Content")),
  ];

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Sidebar(selectedIndex: selectedIndex, onItemSelected: changePage),
              Expanded(child: pages[selectedIndex]),
            ],
          ),
        ),
      ),
    );
  }
}
