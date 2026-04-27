import 'package:examai/data/student_summary_list.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:examai/widgets/dashboard_widgets/lecturerDashboard/recentstudents.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final SupabaseService _db = SupabaseService();

    return FutureBuilder(
      future: Future.wait([_db.getCourses(), _db.getAllExams()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data as List<dynamic>? ?? [[], []];
        final coursesCount = results[0].length;
        final exams = results[1] as List<Map<String, dynamic>>;
        final upcomingExamsCount = exams
            .where((e) => e['status'] == 'Upcoming')
            .length;
        final completedExamsCount = exams
            .where((e) => e['status'] == 'Completed')
            .length;

        final dynamicList = [
          {
            "icon": FontAwesomeIcons.book,
            "iconbg": Colors.blue.shade100,
            "icon_color": Colors.blue,
            "text_color": Colors.green,
            "Bold_text": coursesCount.toString(),
            "grey_text": "Enrolled Courses",
            "color_text": "Active",
          },
          {
            "icon": FontAwesomeIcons.clipboardCheck,
            "iconbg": Colors.purple.shade100,
            "icon_color": Colors.purple,
            "text_color": Colors.blue,
            "Bold_text": completedExamsCount.toString(),
            "grey_text": "Completed Exams",
            "color_text": "Done",
          },
          {
            "icon": FontAwesomeIcons.star,
            "iconbg": Colors.green.shade100,
            "icon_color": Colors.green,
            "text_color": Colors.green,
            "Bold_text": "N/A",
            "grey_text": "Average Grade",
            "color_text": "0%",
          },
          {
            "icon": FontAwesomeIcons.clock,
            "iconbg": Colors.orange.shade100,
            "icon_color": Colors.orange,
            "text_color": Colors.blue,
            "Bold_text": upcomingExamsCount.toString(),
            "grey_text": "Upcoming Exams",
            "color_text": "Next",
          },
        ];

        return SingleChildScrollView(
          child: Column(
            children: [
              DashboardHeader(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: dynamicList.asMap().entries.map((entry) {
                        final index = entry.key;
                        final items = entry.value;
                        return Expanded(
                          child:
                              Summarycard(
                                    iconbg: items["iconbg"] as Color,
                                    icon: items["icon"] as IconData,
                                    boldtext: items["Bold_text"] as String,
                                    greytext: items["grey_text"] as String,
                                    iconcolor: items["icon_color"] as Color,
                                    colortext: items["color_text"] as String,
                                    textcolor: items["text_color"] as Color,
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay: (200 + (index * 100)).ms,
                                    duration: 500.ms,
                                  )
                                  .slideY(begin: 0.5),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Upcomingcontainers(),
                    SizedBox(height: 20),
                    Availablecourses(),
                    SizedBox(height: 20),
                    Examtimetable(),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 200.ms);
      },
    );
  }
}

class Lecturercontent extends StatelessWidget {
  const Lecturercontent({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseService _db = SupabaseService();

    return FutureBuilder(
      future: Future.wait([
        _db.getLecturerStats(),
        _db.getPendingSubmissions(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data as List<dynamic>? ?? [{}, []];
        final statsData = results[0] as Map<String, dynamic>;
        final pendingSubmissions = results[1] as List<Map<String, dynamic>>;

        final summaryItems = [
          {
            "icon": FontAwesomeIcons.book,
            "iconbg": Colors.blue.shade100,
            "icon_color": Colors.blue,
            "text_color": Colors.green,
            "Bold_text": "${statsData['courseCount'] ?? 0}",
            "grey_text": "Active Courses",
            "color_text": "Live",
          },
          {
            "icon": FontAwesomeIcons.users,
            "iconbg": Colors.purple.shade100,
            "icon_color": Colors.purple,
            "text_color": Colors.blue,
            "Bold_text": "${statsData['studentCount'] ?? 0}",
            "grey_text": "Total Students",
            "color_text": "Active",
          },
          {
            "icon": FontAwesomeIcons.star,
            "iconbg": Colors.green.shade100,
            "icon_color": Colors.green,
            "text_color": Colors.green,
            "Bold_text": "${(statsData['avgScore'] as double? ?? 0.0).toStringAsFixed(1)}%",
            "grey_text": "Avg Performance",
            "color_text": "High",
          },
          {
            "icon": FontAwesomeIcons.clock,
            "iconbg": Colors.orange.shade100,
            "icon_color": Colors.orange,
            "text_color": Colors.orange,
            "Bold_text": "${pendingSubmissions.length}",
            "grey_text": "Pending Reviews",
            "color_text": "Due",
          },
        ];

        return SingleChildScrollView(
          child: Column(
            children: [
              DashboardHeaderLt(),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SummaryCardlt(items: summaryItems),
                    SizedBox(height: 5),
                    Hotbuttons(),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Reviewcontainer()),
                        SizedBox(width: 20),
                        Expanded(child: Recentstudents()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
