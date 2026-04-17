import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/data/student_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LecturerAnalyticsPage extends StatelessWidget {
  LecturerAnalyticsPage({super.key});

  static final _coursePerf = [
    {'code': 'CS201', 'title': 'Data Structures', 'avg': 78, 'color': Colors.blue},
    {'code': 'CS301', 'title': 'Database Mgmt', 'avg': 82, 'color': Colors.purple},
    {'code': 'CS401', 'title': 'Operating Systems', 'avg': 75, 'color': Colors.green},
    {'code': 'CS501', 'title': 'Algorithms', 'avg': 80, 'color': Colors.orange},
    {'code': 'CS601', 'title': 'Computer Networks', 'avg': 77, 'color': Colors.pink},
    {'code': 'CS701', 'title': 'Software Engineering', 'avg': 84, 'color': Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    final sortedStudents = List<Map<String, dynamic>>.from(students)
      ..sort(
        (a, b) => (b['Avg_score'] as int).compareTo(a['Avg_score'] as int),
      );
    final top3 = sortedStudents.take(3).toList();
    final bottom3 = sortedStudents.reversed.take(3).toList();

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
                      'Analytics',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Performance overview across all courses',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary stats row
              Row(
                children: [
                  _statCard('${students.length}', 'Total Students', Colors.blue,
                      FontAwesomeIcons.users, 0),
                  SizedBox(width: 16),
                  _statCard('${lecturerCourses.length}', 'Active Courses', Colors.purple,
                      FontAwesomeIcons.book, 100),
                  SizedBox(width: 16),
                  _statCard('79.3%', 'Avg Score', Colors.green,
                      FontAwesomeIcons.chartLine, 200),
                  SizedBox(width: 16),
                  _statCard('96%', 'AI Accuracy', Colors.orange,
                      FontAwesomeIcons.robot, 300),
                ],
              ),

              SizedBox(height: 28),

              // Course performance + top/bottom students
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course performance
                  Expanded(
                    flex: 3,
                    child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 14,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                                child: Text(
                                  'Performance Per Course',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: AppColor.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(24),
                                child: Column(
                                  children: _coursePerf
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final i = entry.key;
                                    final c = entry.value;
                                    final avg = c['avg'] as int;
                                    final color = c['color'] as Color;
                                    return Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                c['code'] as String,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.black,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                '— ${c['title']}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColor.greyText,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '$avg%',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: LinearProgressIndicator(
                                              value: avg / 100,
                                              minHeight: 10,
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                    Color
                                                  >(color),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).animate().fadeIn(
                                          delay: (i * 80).ms,
                                          duration: 400.ms,
                                        ).slideX(
                                          begin: 0.05,
                                          curve: Curves.easeOut,
                                        );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms)
                        .slideY(begin: 0.05),
                  ),

                  SizedBox(width: 20),

                  // Top & Bottom students column
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _StudentsRankCard(
                          title: '🏆  Top Performers',
                          students: top3,
                          accentColor: Colors.green,
                          delay: 500,
                        ),
                        SizedBox(height: 20),
                        _StudentsRankCard(
                          title: '⚠️  Need Attention',
                          students: bottom3,
                          accentColor: Colors.orange,
                          delay: 600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Grade distribution
              Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 14,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grade Distribution',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            _GradeBar(label: 'A (90-100)', count: 2, total: students.length, color: Colors.green),
                            SizedBox(width: 12),
                            _GradeBar(label: 'B (80-89)', count: 3, total: students.length, color: Colors.blue),
                            SizedBox(width: 12),
                            _GradeBar(label: 'C (70-79)', count: 2, total: students.length, color: Colors.orange),
                            SizedBox(width: 12),
                            _GradeBar(label: 'D (60-69)', count: 1, total: students.length, color: Colors.red.shade300),
                            SizedBox(width: 12),
                            _GradeBar(label: 'F (<60)', count: 0, total: students.length, color: Colors.red),
                          ],
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 400.ms)
                  .slideY(begin: 0.05),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String value,
    String label,
    Color color,
    IconData icon,
    int delay,
  ) {
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
                    color: color.withOpacity(0.12),
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

class _StudentsRankCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> students;
  final Color accentColor;
  final int delay;

  const _StudentsRankCard({
    required this.title,
    required this.students,
    required this.accentColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColor.black,
                  ),
                ),
              ),
              Divider(height: 20),
              ...students.map((s) {
                final score = s['Avg_score'] as int;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(s['pic'] as String),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          s['name'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$score%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 8),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: delay.ms, duration: 400.ms)
        .slideY(begin: 0.05, curve: Curves.easeOut);
  }
}

class _GradeBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _GradeBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : count / total;
    return Expanded(
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: pct == 0 ? 0.02 : pct,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style:  TextStyle(fontSize: 11, color: AppColor.greyText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
