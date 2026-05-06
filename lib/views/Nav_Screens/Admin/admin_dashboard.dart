import 'package:examai/constants/app_color.dart';
import 'package:examai/views/Nav_Screens/Admin/user_management.dart';
import 'package:examai/views/Nav_Screens/Admin/course_management.dart';
import 'package:examai/views/Nav_Screens/Admin/system_activity.dart';
import 'package:examai/views/Nav_Screens/dashboard.dart';
import 'package:examai/views/Nav_Screens/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdminDashboard extends StatefulWidget {
  final String userRole;
  const AdminDashboard({super.key, this.userRole = 'admin'});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _buildPages();
  }

  void _buildPages() {
    pages = [
      Dashboard(userRole: widget.userRole),
      const UserManagement(),
      const CourseManagement(),
      const SystemActivity(),
      const Center(child: Text("Security Page")),
      const Center(child: Text("Settings Page")),
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
            child: pages[selectedIndex]
                .animate(key: ValueKey(selectedIndex))
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.02, end: 0, curve: Curves.easeInOut),
          ),
        ],
      ),
    );
  }
}
