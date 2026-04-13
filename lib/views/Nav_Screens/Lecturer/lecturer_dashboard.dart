import 'package:examai/constants/app_color.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_analytics_page.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_courses.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_exams_page.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_review_page.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_scan_page.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_timetable.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_student_page.dart';
import 'package:examai/views/Nav_Screens/dashboard.dart';
import 'package:examai/views/Nav_Screens/sidebar.dart';
import 'package:flutter/material.dart';

class LecturerDashboard extends StatefulWidget {
  final String userRole;
  const LecturerDashboard({super.key, this.userRole = 'lecturer'});

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  int selectedIndex = 0;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _buildPages();
  }

  @override
  void didUpdateWidget(covariant LecturerDashboard oldWidget) {
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
      const LecturerCourses(),
      const LecturerExamsPage(),
      const LecturerScanPage(),
      const LecturerReviewPage(),
      const LecturerStudentPage(),
      LecturerTimetable(),
      LecturerAnalyticsPage(),
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
            child: SingleChildScrollView(child: pages[selectedIndex]),
          ),
        ],
      ),
    );
  }
}
