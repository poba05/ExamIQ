import 'package:examai/views/Nav_Screens/Lecturer/create_exam_page.dart';
import 'package:examai/views/Nav_Screens/Lecturer/live_monitoring_page.dart';
import 'package:examai/views/Nav_Screens/Lecturer/lecturer_review_page.dart';
import 'package:examai/constants/app_color.dart';

import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/containers/lecturer_exam_cont.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:examai/utils/supabase_service.dart';

class LecturerExamsPage extends StatefulWidget {
  const LecturerExamsPage({super.key});

  @override
  State<LecturerExamsPage> createState() => _LecturerExamsPageState();
}

class _LecturerExamsPageState extends State<LecturerExamsPage> {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _supabaseService.getLecturerExams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<Map<String, dynamic>> exams = snapshot.data ?? [];

        return Column(
          children: [
            TopContainerLt(
              title: "Exams",
              subtitle: "Manage your exams and grading",
              onPressed: (BuildContext context) {},
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Create and Manage all your Exams",
                      style: TextStyle(fontSize: 14, color: AppColor.greyText),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GradientButtonLg(
                    horizontalPadding: 24,
                    verticalPadding: 12,
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateExamPage()),
                      );
                      if (result == true) {
                        setState(() {}); // Refresh list
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.plus,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Create Exam",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: exams.isEmpty
                  ? Center(child: Text("No exams found. Create one!"))
                  : Column(
                      children: exams.asMap().entries.map((entry) {
                        final index = entry.key;
                        final exam = entry.value;
                        final course =
                            exam['courses'] as Map<String, dynamic>? ?? {};

                        final questionsList = exam['questions'] as List? ?? [];
                        final submissionsList = exam['submissions'] as List? ?? [];
                        final enrollmentsList = course['enrollments'] as List? ?? [];

                        final noofquestions = questionsList.length;
                        final noofstudents = enrollmentsList.length;
                        
                        final submittedprogress = submissionsList.length;
                        final submittedtotal = noofstudents;

                        final gradedList = submissionsList.where((s) => s['score'] != null).toList();
                        final gradedprogress = gradedList.length;
                        final gradedtotal = submissionsList.length;
                        final gradedreview = submissionsList.where((s) => s['score'] == null).length;

                        double averageScore = 0.0;
                        if (gradedprogress > 0) {
                          double totalScore = gradedList.fold(0.0, (sum, s) => sum + (s['score'] as num).toDouble());
                          averageScore = totalScore / gradedprogress;
                        }
                        final averageText = gradedprogress > 0 ? "${averageScore.toStringAsFixed(1)}%" : "N/A";

                        return LecturerExamCont(
                              title: exam['title']?.toString() ?? "N/A",
                              subtitle: course['course_code']?.toString() ?? "",
                              iconbg: Colors.blue.shade100,
                              iconcolor: Colors.blue,
                              timeduration:
                                  (exam['duration_minutes'] as num?)?.toInt() ??
                                  0,
                              noofquestions: noofquestions,
                              noofstudents: noofstudents,
                              average: averageText,
                              submittedprogress: submittedprogress,
                              submittedtotal: submittedtotal,
                              gradedprogress: gradedprogress,
                              gradedtotal: gradedtotal,
                              gradedreview: gradedreview,
                              dateandtime: exam['exam_date']?.toString() ?? "",
                              onLiveMonitor: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LiveMonitoringPage(exam: exam),
                                  ),
                                );
                              },
                              onDetailsPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: Text("Exam Submissions - ${exam['title']}"),
                                        backgroundColor: AppColor.navyblue,
                                        foregroundColor: Colors.white,
                                      ),
                                      body: LecturerReviewPage(initialExam: exam),
                                    ),
                                  ),
                                );
                              },
                            )
                            .animate()
                            .fadeIn(delay: (index * 200).ms)
                            .slideY(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            );

                      }).toList(),
                    ),
            ),
          ],
        );
      },
    );
  }
}
