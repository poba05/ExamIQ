import 'package:examai/views/Dashboard/student_dashboard/dashboard.dart';
import 'package:examai/views/Dashboard/student_dashboard/sidebar.dart';
import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  final String userRole;
  const StudentDashboard({super.key, this.userRole = 'student'});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int selectedIndex = 0;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _updatePagesForRole();
  }

  @override
  void didUpdateWidget(covariant StudentDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userRole != oldWidget.userRole) {
      setState(() {
        _updatePagesForRole();
        // Reset index to avoid errors if the new list is shorter
        selectedIndex = 0;
      });
    }
  }

  void _updatePagesForRole() {
    if (widget.userRole == 'student') {
      pages = [
        Dashboard(userRole: widget.userRole),
        const Center(child: Text("My Courses Content")),
        const Center(child: Text("Exams Content")),
        const Center(child: Text("Timetable Content")),
        const Center(child: Text("Results Content")),
      ];
    } else {
      // Corresponds to the other role's sidebar items
      pages = [
        Dashboard(
          userRole: widget.userRole,
        ), // You might want a different dashboard for other roles
        const Center(child: Text("Courses Content")),
        const Center(child: Text("Create Exam Content")),
        const Center(child: Text("Students Content")),
        const Center(child: Text("Analytics Content")),
      ];
    }
  }

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: changePage,
            userRole: widget.userRole,
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(child: pages[selectedIndex]),
            ),
          ),
        ],
      ),
    );
  }
}
