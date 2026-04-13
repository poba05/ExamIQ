import 'package:examai/constants/app_color.dart';
import 'package:examai/views/Nav_Screens/Student/student_courses_page.dart';
import 'package:examai/views/Nav_Screens/Student/student_exams_page.dart';
import 'package:examai/views/Nav_Screens/Student/student_timetable_page.dart';
import 'package:examai/views/Nav_Screens/Student/student_results_page.dart';
import 'package:examai/views/Nav_Screens/dashboard.dart';
import 'package:examai/views/Nav_Screens/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    _buildPages();
  }

  @override
  void didUpdateWidget(covariant StudentDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userRole != oldWidget.userRole) {
      setState(() {
        _buildPages();
        selectedIndex = 0;
      });
    }
  }

  void _buildPages() {
    pages = [
      Dashboard(userRole: widget.userRole),
      StudentCoursesPage(),
      StudentExamsPage(),
      StudentTimetablePage(),
      StudentResultsPage(),
    ];
  }

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.palebackground,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: changePage,
            userRole: widget.userRole,
          ),
          Expanded(
            child: SingleChildScrollView(child: pages[selectedIndex])
                .animate(key: ValueKey(selectedIndex))
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.02, end: 0, curve: Curves.easeInOut),
          ),
        ],
      ),
    );
  }
}
