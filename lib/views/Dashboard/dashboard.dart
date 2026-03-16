import 'package:examai/data/student_summary_list.dart';
import 'package:examai/widgets/dashboard_widgets/lecturerDashboard/mycoursescontainer.dart';
import 'package:examai/widgets/dashboard_widgets/lecturerDashboard/scannercontainer.dart';
import 'package:examai/widgets/dashboard_widgets/lecturerDashboard/dahsboard_header_lt.dart';
import 'package:examai/widgets/dashboard_widgets/lecturerDashboard/hotbuttons.dart';
import 'package:examai/widgets/dashboard_widgets/lecturerDashboard/reviewcontainer.dart';
import 'package:examai/widgets/dashboard_widgets/lecturerDashboard/summary_card.dart';
import 'package:examai/widgets/dashboard_widgets/studentDashboard/availablecourses.dart';
import 'package:examai/widgets/dashboard_widgets/studentDashboard/dashboard_header.dart';
import 'package:examai/widgets/dashboard_widgets/studentDashboard/examtimetable.dart';
import 'package:examai/widgets/dashboard_widgets/studentDashboard/summarycard.dart';
import 'package:examai/widgets/dashboard_widgets/studentDashboard/upcomingcontainers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget that represents the main dashboard screen for a student.
///
/// It displays a summary of the student's activities, upcoming exams,
/// available courses, and an exam timetable.
class Dashboard extends StatefulWidget {
  final String userRole;
  const Dashboard({super.key, this.userRole = 'student'});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    // The main scrollable layout for the dashboard.
    return widget.userRole == 'student' ? StudentContent() : Lecturercontent();
  }
}

class StudentContent extends StatelessWidget {
  const StudentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header section of the dashboard.
        DashboardHeader(),
        SizedBox(height: 20),
        // Main content area of the dashboard with padding.
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Row of summary cards (Enrolled Courses, Active Exams, etc.).
              Row(
                // Dynamically generate summary cards from the `mylist` data.
                children: mylist.asMap().entries.map((entry) {
                  final index = entry.key;
                  final items = entry.value;
                  return Expanded(
                        // Each card is a container with styling.
                        child: Summarycard(
                          iconbg: items["iconbg"] as Color,
                          icon: items["icon"] as IconData,
                          boldtext: items["Bold_text"] as String,
                          greytext: items["grey_text"] as String,
                          iconcolor: items["icon_color"] as Color,
                          colortext: items["color_text"] as String,
                          textcolor: items["text_color"] as Color,
                        ),
                      )
                      // Animate the card with a fade-in and slide-up effect.
                      .animate()
                      .fadeIn(delay: (200 + (index * 100)).ms, duration: 500.ms)
                      .slideY(begin: 0.5);
                }).toList(),
              ),
              SizedBox(height: 20),
              // "Upcoming Exams" section.
              Upcomingcontainers(),
              SizedBox(height: 20),
              Availablecourses(),
              SizedBox(height: 20),
              Examtimetable(),
            ],
          ),
        ),
      ],
      // Animate the entire dashboard content on load.
    ).animate().fadeIn(duration: 200.ms);
  }
}

class Lecturercontent extends StatelessWidget {
  const Lecturercontent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DahsboardHeaderLt(),
        SizedBox(height: 20),
        // Main content area of the dashboard with padding.
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Row of summary cards (Enrolled Courses, Active Exams, etc.).
              SummaryCardlt(),
              SizedBox(height: 5),
              Hotbuttons(),
              SizedBox(height: 20),
              Reviewcontainer(),
              SizedBox(height: 20),
              Scannercontainer(),
              SizedBox(height: 20),
              Mycoursescontainer(),
            ],
          ),
        ),
      ],
    );
  }
}
