import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentCoursesPage extends StatefulWidget {
  StudentCoursesPage({super.key});

  @override
  State<StudentCoursesPage> createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
  final List<Map<String, dynamic>> _enrolled = [
    {
      'title': 'Data Structures',
      'code': 'CS201',
      'lecturer': 'Dr. Smith',
      'progress': 0.72,
      'grade': 'B+',
      'icon': FontAwesomeIcons.laptopCode,
      'iconbg': Colors.blue.shade100,
      'iconcolor': Colors.blue,
      'nextExam': 'Apr 28, 2026',
      'status': 'Active',
    },
    {
      'title': 'Database Management',
      'code': 'CS301',
      'lecturer': 'Prof. Adeyemi',
      'progress': 0.55,
      'grade': 'B',
      'icon': FontAwesomeIcons.database,
      'iconbg': Colors.purple.shade100,
      'iconcolor': Colors.purple,
      'nextExam': 'May 3, 2026',
      'status': 'Active',
    },
    {
      'title': 'Operating Systems',
      'code': 'CS401',
      'lecturer': 'Dr. Okonkwo',
      'progress': 0.88,
      'grade': 'A',
      'icon': FontAwesomeIcons.server,
      'iconbg': Colors.green.shade100,
      'iconcolor': Colors.green,
      'nextExam': 'May 10, 2026',
      'status': 'Active',
    },
    {
      'title': 'Algorithms',
      'code': 'CS501',
      'lecturer': 'Dr. James',
      'progress': 0.40,
      'grade': 'C+',
      'icon': FontAwesomeIcons.codeBranch,
      'iconbg': Colors.orange.shade100,
      'iconcolor': Colors.orange,
      'nextExam': 'May 15, 2026',
      'status': 'Active',
    },
    {
      'title': 'Computer Networks',
      'code': 'CS601',
      'lecturer': 'Prof. Nwosu',
      'progress': 0.95,
      'grade': 'A+',
      'icon': FontAwesomeIcons.networkWired,
      'iconbg': Colors.pink.shade100,
      'iconcolor': Colors.pink,
      'nextExam': 'Completed',
      'status': 'Completed',
    },
    {
      'title': 'Software Engineering',
      'code': 'CS701',
      'lecturer': 'Dr. Eze',
      'progress': 0.30,
      'grade': 'In Progress',
      'icon': FontAwesomeIcons.gears,
      'iconbg': Colors.indigo.shade100,
      'iconcolor': Colors.indigo,
      'nextExam': 'May 20, 2026',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final active = _enrolled.where((e) => e['status'] == 'Active').length;
    final completed = _enrolled.where((e) => e['status'] == 'Completed').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
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
                      'My Courses',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$active active · $completed completed',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.greyText,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  FontAwesomeIcons.solidBell,
                  color: AppColor.greyText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats row
              Row(
                children: [
                  _statChip(
                    '${_enrolled.length}',
                    'Enrolled',
                    Colors.blue,
                    FontAwesomeIcons.bookOpen,
                  ),
                  SizedBox(width: 16),
                  _statChip(
                    '$active',
                    'Active',
                    Colors.green,
                    FontAwesomeIcons.circleCheck,
                  ),
                  SizedBox(width: 16),
                  _statChip(
                    '$completed',
                    'Completed',
                    Colors.grey,
                    FontAwesomeIcons.flagCheckered,
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

              SizedBox(height: 28),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _enrolled.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 420,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final course = _enrolled[index];
                  final progress = course['progress'] as double;
                  final isCompleted = course['status'] == 'Completed';

                  return _CourseCard(
                        course: course,
                        progress: progress,
                        isCompleted: isCompleted,
                      )
                      .animate()
                      .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOut);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statChip(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
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
                  fontSize: 13,
                  color: AppColor.greyText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  final double progress;
  final bool isCompleted;

  const _CourseCard({
    required this.course,
    required this.progress,
    required this.isCompleted,
  });

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _hovered = false;

  Color get _progressColor {
    if (widget.progress >= 0.75) return Colors.green;
    if (widget.progress >= 0.5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform:
            _hovered ? Matrix4.translationValues(0.0, -6.0, 0.0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? Colors.blue.withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _hovered ? 20 : 10,
              spreadRadius: _hovered ? 2 : 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: c['iconbg'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      c['icon'] as IconData,
                      color: c['iconcolor'] as Color,
                      size: 20,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isCompleted
                          ? Colors.grey.shade100
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      c['status'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: widget.isCompleted ? Colors.grey : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Text(
                c['title'] as String,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '${c['code']} · ${c['lecturer']}',
                style:  TextStyle(fontSize: 13, color: AppColor.greyText),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(fontSize: 12, color: AppColor.greyText),
                  ),
                  Spacer(),
                  Text(
                    '${(widget.progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _progressColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: widget.progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.calendar,
                    size: 12,
                    color: AppColor.greyText,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Next: ${c['nextExam']}',
                    style:
                         TextStyle(fontSize: 12, color: AppColor.greyText),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      c['grade'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
