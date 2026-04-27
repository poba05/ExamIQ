import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:examai/utils/supabase_service.dart';

class StudentResultsPage extends StatefulWidget {
  const StudentResultsPage({super.key});

  @override
  State<StudentResultsPage> createState() => _StudentResultsPageState();
}

class _StudentResultsPageState extends State<StudentResultsPage> {
  final SupabaseService _supabaseService = SupabaseService();

  String _getGrade(int score) {
    if (score >= 90) return 'A+';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    return 'F';
  }

  Color _gradeColor(int score) {
    if (score >= 70) return Colors.green;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _supabaseService.getStudentSubmissions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final results = snapshot.data ?? [];
        
        final double avgScore = results.isEmpty 
          ? 0.0 
          : results.fold(0.0, (sum, r) => sum + (r['score'] as num? ?? 0.0)) / results.length;
        
        final bestScore = results.isEmpty 
          ? 0 
          : results.map((r) => (r['score'] as num? ?? 0).toInt()).reduce((a, b) => a > b ? a : b);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'My Results',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'View your academic performance',
                          style: TextStyle(fontSize: 14, color: AppColor.greyText),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(FontAwesomeIcons.solidBell, color: AppColor.greyText, size: 20),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Summary cards
                  Row(
                    children: [
                      _SummaryCard(
                        label: 'Average Score',
                        value: '${avgScore.toStringAsFixed(1)}%',
                        icon: FontAwesomeIcons.chartLine,
                        color: Colors.blue,
                        delay: 0,
                      ),
                      SizedBox(width: 16),
                      _SummaryCard(
                        label: 'Overall Grade',
                        value: _getGrade(avgScore.toInt()),
                        icon: FontAwesomeIcons.solidStar,
                        color: Colors.purple,
                        delay: 100,
                      ),
                      SizedBox(width: 16),
                      _SummaryCard(
                        label: 'Exams Completed',
                        value: '${results.length}',
                        icon: FontAwesomeIcons.circleCheck,
                        color: Colors.green,
                        delay: 200,
                      ),
                      SizedBox(width: 16),
                      _SummaryCard(
                        label: 'Best Score',
                        value: '${bestScore}%',
                        icon: FontAwesomeIcons.trophy,
                        color: Colors.amber,
                        delay: 300,
                      ),
                    ],
                  ),

                  SizedBox(height: 28),

                  // Results table
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          child: Text(
                            'Exam Results',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                        Divider(height: 1),
                        results.isEmpty 
                        ? Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Center(child: Text("No results found.", style: TextStyle(color: AppColor.greyText))),
                          )
                        : Column(
                          children: results.asMap().entries.map((entry) {
                            final index = entry.key;
                            final result = entry.value;
                            final score = (result['score'] as num? ?? 0).toInt();
                            final gColor = _gradeColor(score);
                            final exam = result['exams'] as Map? ?? {};
                            final course = exam['courses'] as Map? ?? {};

                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 46,
                                      width: 46,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.fileLines,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exam['title']?.toString() ?? 'Exam',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            '${course['course_code'] ?? 'N/A'} · ${exam['exam_date'] ?? 'TBD'}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.greyText,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            result['feedback']?.toString() ?? 'No feedback provided yet.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${score}%',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: gColor,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: gColor.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Grade: ${_getGrade(score)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: gColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          width: 120,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child:
                                                LinearProgressIndicator(
                                              value: score / 100,
                                              minHeight: 7,
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                    Color
                                                  >(gColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(
                              delay: (index * 100).ms,
                              duration: 400.ms,
                            )
                            .slideX(begin: 0.05, curve: Curves.easeOut);
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideY(begin: 0.05, curve: Curves.easeOut),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final int delay;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.greyText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          .animate()
          .fadeIn(delay: delay.ms, duration: 400.ms)
          .slideY(begin: 0.1, curve: Curves.easeOut),
    );
  }
}
