import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:examai/views/Nav_Screens/Student/exam_session_page.dart';

import 'package:examai/utils/supabase_service.dart';

class Upcomingcontainers extends StatelessWidget {
  const Upcomingcontainers({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseService _db = SupabaseService();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _db.getAllExams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final allExams = snapshot.data ?? [];
        final upcomingExams = allExams
            .where((e) => e['status'] == 'Upcoming' || e['status'] == 'Active')
            .take(2)
            .toList();

        return Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Upcoming Exams",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
              ),
              upcomingExams.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No upcoming exams.")),
                    )
                  : Column(
                      children: upcomingExams.map((exam) {
                        final course = exam['courses'] as Map? ?? {};
                        final lecturer =
                            (course['profiles'] as Map?)?['full_name'] ?? 'TBD';
                        final isActive = exam['status'] == 'Active';

                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.green.shade100
                                            : Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        isActive
                                            ? FontAwesomeIcons.bolt
                                            : FontAwesomeIcons.laptopCode,
                                        color: isActive
                                            ? Colors.green
                                            : Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exam['title'] ?? 'Exam',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "${course['course_code'] ?? 'N/A'} • ${exam['duration_minutes'] ?? 0} minutes",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.greyText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: isActive
                                          ? () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => ExamSessionPage(exam: exam),
                                                ),
                                              );
                                            }
                                          : () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isActive
                                            ? Colors.green
                                            : AppColor.primaryBlue,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        isActive ? "Start Now" : "View Details",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.calendar,
                                      size: 13,
                                      color: AppColor.greyText,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${exam['exam_date']} ${exam['start_time']}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.greyText,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Icon(
                                      FontAwesomeIcons.user,
                                      size: 13,
                                      color: AppColor.greyText,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      lecturer,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.1);
      },
    );
  }
}
