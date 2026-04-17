import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentResultsPage extends StatelessWidget {
  StudentResultsPage({super.key});

  static final List<Map<String, dynamic>> _results = [
    {
      'title': 'Computer Networks Final',
      'code': 'CS601',
      'date': 'Mar 10, 2026',
      'score': 87,
      'grade': 'A',
      'icon': FontAwesomeIcons.networkWired,
      'iconbg': Colors.pink.shade100,
      'iconcolor': Colors.pink,
      'feedback': 'Excellent understanding of network protocols and TCP/IP stack.',
    },
    {
      'title': 'Algorithms Mid-Semester',
      'code': 'CS501',
      'date': 'Feb 20, 2026',
      'score': 73,
      'grade': 'B',
      'icon': FontAwesomeIcons.codeBranch,
      'iconbg': Colors.orange.shade100,
      'iconcolor': Colors.orange,
      'feedback': 'Good grasp of dynamic programming. Improve on graph algorithms.',
    },
    {
      'title': 'Data Structures Quiz 2',
      'code': 'CS201',
      'date': 'Jan 30, 2026',
      'score': 91,
      'grade': 'A+',
      'icon': FontAwesomeIcons.laptopCode,
      'iconbg': Colors.blue.shade100,
      'iconcolor': Colors.blue,
      'feedback': 'Outstanding performance. Strong command of tree traversal algorithms.',
    },
    {
      'title': 'Database Management Quiz',
      'code': 'CS301',
      'date': 'Jan 15, 2026',
      'score': 68,
      'grade': 'C+',
      'icon': FontAwesomeIcons.database,
      'iconbg': Colors.purple.shade100,
      'iconcolor': Colors.purple,
      'feedback': 'Needs improvement in SQL optimization and normalization techniques.',
    },
    {
      'title': 'Operating Systems Test',
      'code': 'CS401',
      'date': 'Jan 5, 2026',
      'score': 95,
      'grade': 'A+',
      'icon': FontAwesomeIcons.server,
      'iconbg': Colors.green.shade100,
      'iconcolor': Colors.green,
      'feedback': 'Exceptional knowledge of process scheduling and memory management.',
    },
  ];

  double get _avgScore =>
      _results.fold(0.0, (sum, r) => sum + (r['score'] as int)) /
      _results.length;

  String get _overallGrade {
    if (_avgScore >= 90) return 'A+';
    if (_avgScore >= 80) return 'A';
    if (_avgScore >= 70) return 'B';
    if (_avgScore >= 60) return 'C';
    return 'D';
  }

  Color _gradeColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
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
                    value: '${_avgScore.toStringAsFixed(1)}%',
                    icon: FontAwesomeIcons.chartLine,
                    color: Colors.blue,
                    delay: 0,
                  ),
                  SizedBox(width: 16),
                  _SummaryCard(
                    label: 'Overall Grade',
                    value: _overallGrade,
                    icon: FontAwesomeIcons.solidStar,
                    color: Colors.purple,
                    delay: 100,
                  ),
                  SizedBox(width: 16),
                  _SummaryCard(
                    label: 'Exams Completed',
                    value: '${_results.length}',
                    icon: FontAwesomeIcons.circleCheck,
                    color: Colors.green,
                    delay: 200,
                  ),
                  SizedBox(width: 16),
                  _SummaryCard(
                    label: 'Best Score',
                    value:
                        '${_results.map((r) => r['score'] as int).reduce((a, b) => a > b ? a : b)}%',
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
                        Column(
                          children: _results.asMap().entries.map((entry) {
                            final index = entry.key;
                            final result = entry.value;
                            final score = result['score'] as int;
                            final gColor = _gradeColor(score);

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
                                            color: result['iconbg'] as Color,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            result['icon'] as IconData,
                                            color: result['iconcolor'] as Color,
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
                                                result['title'] as String,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.black,
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                '${result['code']} · ${result['date']}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.greyText,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                result['feedback'] as String,
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
                                                'Grade: ${result['grade']}',
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
