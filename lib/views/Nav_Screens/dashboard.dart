import 'package:examai/constants/app_color.dart';
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
    if (widget.userRole == 'student') {
      return StudentContent();
    } else if (widget.userRole == 'lecturer') {
      return Lecturercontent();
    } else {
      return AdminContent();
    }
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
            "Bold_text":
                "${(statsData['avgScore'] as double? ?? 0.0).toStringAsFixed(1)}%",
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

class AdminContent extends StatelessWidget {
  const AdminContent({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseService _db = SupabaseService();

    return FutureBuilder(
      future: Future.wait([_db.getAllProfiles(), _db.getCourses()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data as List<dynamic>? ?? [[], []];
        final allProfiles = results[0] as List<Map<String, dynamic>>;
        final allCourses = results[1] as List<Map<String, dynamic>>;

        final studentCount = allProfiles
            .where((p) => p['role'] == 'student')
            .length;
        final lecturerCount = allProfiles
            .where((p) => p['role'] == 'lecturer')
            .length;

        final summaryItems = [
          {
            "icon": FontAwesomeIcons.users,
            "iconbg": Colors.blue.shade100,
            "icon_color": Colors.blue,
            "text_color": Colors.blue,
            "Bold_text": "$studentCount",
            "grey_text": "Total Students",
            "color_text": "Registered",
          },
          {
            "icon": FontAwesomeIcons.chalkboardUser,
            "iconbg": Colors.purple.shade100,
            "icon_color": Colors.purple,
            "text_color": Colors.purple,
            "Bold_text": "$lecturerCount",
            "grey_text": "Total Lecturers",
            "color_text": "Staff",
          },
          {
            "icon": FontAwesomeIcons.book,
            "iconbg": Colors.green.shade100,
            "icon_color": Colors.green,
            "text_color": Colors.green,
            "Bold_text": "${allCourses.length}",
            "grey_text": "Total Courses",
            "color_text": "Academic",
          },
          {
            "icon": FontAwesomeIcons.shieldHalved,
            "iconbg": Colors.orange.shade100,
            "icon_color": Colors.orange,
            "text_color": Colors.orange,
            "Bold_text": "Active",
            "grey_text": "System Status",
            "color_text": "Secure",
          },
        ];

        return SingleChildScrollView(
          child: Column(
            children: [
              const DashboardHeaderLt(), // Can reuse lecturer header for now or make admin one
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SummaryCardlt(items: summaryItems),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "System Activity",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Placeholder for a chart or activity list
                                ListTile(
                                  leading: const Icon(
                                    FontAwesomeIcons.userPlus,
                                    color: Colors.green,
                                  ),
                                  title: const Text("New user registered"),
                                  subtitle: const Text("2 minutes ago"),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    FontAwesomeIcons.book,
                                    color: Colors.blue,
                                  ),
                                  title: const Text("Course 'CSC 401' updated"),
                                  subtitle: const Text("1 hour ago"),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    FontAwesomeIcons.triangleExclamation,
                                    color: Colors.orange,
                                  ),
                                  title: const Text("Failed login attempt"),
                                  subtitle: const Text("3 hours ago"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Quick Actions",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _quickAction(
                                  context,
                                  "Add Lecturer",
                                  FontAwesomeIcons.userPlus,
                                ),
                                _quickAction(
                                  context,
                                  "System Backup",
                                  FontAwesomeIcons.database,
                                ),
                                _quickAction(
                                  context,
                                  "Broadcast Msg",
                                  FontAwesomeIcons.bullhorn,
                                ),
                              ],
                            ),
                          ),
                        ),
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

  Widget _quickAction(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColor.primaryBlue),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
