import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentExamsPage extends StatefulWidget {
  StudentExamsPage({super.key});

  @override
  State<StudentExamsPage> createState() => _StudentExamsPageState();
}

class _StudentExamsPageState extends State<StudentExamsPage> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Upcoming', 'Active', 'Completed'];

  final List<Map<String, dynamic>> _exams = [
    {
      'title': 'Data Structures Final Exam',
      'code': 'CS201',
      'lecturer': 'Dr. Smith',
      'date': 'Apr 28, 2026',
      'time': '2:00 PM',
      'duration': '60 min',
      'questions': 50,
      'status': 'Upcoming',
      'icon': FontAwesomeIcons.laptopCode,
      'iconbg': Colors.blue.shade100,
      'iconcolor': Colors.blue,
      'score': null,
    },
    {
      'title': 'Database Management Midterm',
      'code': 'CS301',
      'lecturer': 'Prof. Adeyemi',
      'date': 'May 3, 2026',
      'time': '10:00 AM',
      'duration': '90 min',
      'questions': 40,
      'status': 'Upcoming',
      'icon': FontAwesomeIcons.database,
      'iconbg': Colors.purple.shade100,
      'iconcolor': Colors.purple,
      'score': null,
    },
    {
      'title': 'Operating Systems Quiz',
      'code': 'CS401',
      'lecturer': 'Dr. Okonkwo',
      'date': 'Today',
      'time': 'Now',
      'duration': '30 min',
      'questions': 25,
      'status': 'Active',
      'icon': FontAwesomeIcons.server,
      'iconbg': Colors.green.shade100,
      'iconcolor': Colors.green,
      'score': null,
    },
    {
      'title': 'Computer Networks Final',
      'code': 'CS601',
      'lecturer': 'Prof. Nwosu',
      'date': 'Mar 10, 2026',
      'time': '9:00 AM',
      'duration': '120 min',
      'questions': 60,
      'status': 'Completed',
      'icon': FontAwesomeIcons.networkWired,
      'iconbg': Colors.pink.shade100,
      'iconcolor': Colors.pink,
      'score': '87%',
    },
    {
      'title': 'Algorithms Mid-Semester',
      'code': 'CS501',
      'lecturer': 'Dr. James',
      'date': 'Feb 20, 2026',
      'time': '11:00 AM',
      'duration': '60 min',
      'questions': 30,
      'status': 'Completed',
      'icon': FontAwesomeIcons.codeBranch,
      'iconbg': Colors.orange.shade100,
      'iconcolor': Colors.orange,
      'score': '73%',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedTab == 0) return _exams;
    final tab = _tabs[_selectedTab];
    return _exams.where((e) => e['status'] == tab).toList();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Active': return Colors.green;
      case 'Upcoming': return Colors.blue;
      case 'Completed': return Colors.grey;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final counts = {
      for (var t in _tabs)
        t: t == 'All'
            ? _exams.length
            : _exams.where((e) => e['status'] == t).length,
    };

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
                      'My Exams',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track all your exam sessions',
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
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _tabs.asMap().entries.map((entry) {
                    final i = entry.key;
                    final tab = entry.value;
                    final selected = _selectedTab == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? AppColor.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          '${tab} (${counts[tab]})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: selected
                                ? AppColor.primaryBlue
                                : AppColor.greyText,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ).animate().fadeIn(duration: 300.ms),

              SizedBox(height: 24),

              // Exam list
              Column(
                children: _filtered.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exam = entry.value;
                  final status = exam['status'] as String;
                  final sColor = _statusColor(status);
                  final isActive = status == 'Active';
                  final isCompleted = status == 'Completed';

                  return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(16),
                          border: isActive
                              ? Border.all(
                                  color: Colors.green.shade300,
                                  width: 2,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 52,
                                width: 52,
                                decoration: BoxDecoration(
                                  color: exam['iconbg'] as Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  exam['icon'] as IconData,
                                  color: exam['iconcolor'] as Color,
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exam['title'] as String,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${exam['code']} · ${exam['lecturer']}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColor.greyText,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Wrap(
                                      spacing: 16,
                                      children: [
                                        _metaChip(
                                          FontAwesomeIcons.calendar,
                                          '${exam['date']} · ${exam['time']}',
                                        ),
                                        _metaChip(
                                          FontAwesomeIcons.clock,
                                          exam['duration'] as String,
                                        ),
                                        _metaChip(
                                          FontAwesomeIcons.circleQuestion,
                                          '${exam['questions']} questions',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: sColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: sColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  if (isCompleted && exam['score'] != null)
                                    Text(
                                      'Score: ${exam['score']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.black,
                                      ),
                                    )
                                  else if (isActive)
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Start Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade100,
                                        elevation: 0,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'View Details',
                                        style: TextStyle(
                                          color: AppColor.greyText,
                                          fontWeight: FontWeight.bold,
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
                      .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOut);
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColor.greyText),
        SizedBox(width: 5),
        Text(label, style:  TextStyle(fontSize: 12, color: AppColor.greyText)),
      ],
    );
  }
}
