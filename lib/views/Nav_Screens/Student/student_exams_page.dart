import 'package:examai/constants/app_color.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentExamsPage extends StatefulWidget {
  const StudentExamsPage({super.key});

  @override
  State<StudentExamsPage> createState() => _StudentExamsPageState();
}

class _StudentExamsPageState extends State<StudentExamsPage> {
  final SupabaseService _supabaseService = SupabaseService();
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Upcoming', 'Active', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _supabaseService.getAllExams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<Map<String, dynamic>> rawExams = snapshot.data ?? [];

        // Map Supabase data to local format
        final List<Map<String, dynamic>> exams = rawExams.map((e) {
          final course = e['courses'] as Map<String, dynamic>? ?? {};
          final lecturer = (course['profiles'] != null)
              ? course['profiles']['full_name']
              : 'TBD';

          return {
            'title': e['title'] ?? 'Exam',
            'code': course['course_code'] ?? 'N/A',
            'lecturer': lecturer,
            'date': e['exam_date'] ?? 'TBD',
            'time': e['start_time'] ?? 'TBD',
            'duration': '${e['duration_minutes'] ?? 0} min',
            'questions': 0, // Placeholder
            'status': e['status'] ?? 'Upcoming',
            'icon': FontAwesomeIcons.book,
            'iconbg': Colors.blue.shade100,
            'iconcolor': Colors.blue,
            'score': null,
          };
        }).toList();

        final filtered = _selectedTab == 0
            ? exams
            : exams.where((e) => e['status'] == _tabs[_selectedTab]).toList();

        final counts = {
          for (var t in _tabs)
            t: t == 'All'
                ? exams.length
                : exams.where((e) => e['status'] == t).length,
        };

        return SingleChildScrollView(
          child: Column(
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                          const SizedBox(height: 4),
                          Text(
                            'Track all your exam sessions',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.greyText,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _tabs.asMap().entries.map((entry) {
                          final i = entry.key;
                          final tab = entry.value;
                          final selected = _selectedTab == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedTab = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColor.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
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

                    const SizedBox(height: 24),

                    // Exam list
                    Column(
                      children: filtered.asMap().entries.map((entry) {
                        final index = entry.key;
                        final exam = entry.value;
                        final status = exam['status'] as String;
                        final sColor = _statusColor(status);
                        final isActive = status == 'Active';
                        final isCompleted = status == 'Completed';

                        return Container(
                              margin: const EdgeInsets.only(bottom: 16),
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
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
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
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exam['title'] as String,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${exam['code']} · ${exam['lecturer']}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColor.greyText,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
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
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: sColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
                                        const SizedBox(height: 12),
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
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
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
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              elevation: 0,
                                              padding: const EdgeInsets.symmetric(
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
          ),
        );
      },
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColor.greyText),
        SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, color: AppColor.greyText)),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Completed':
        return Colors.blue;
      case 'Upcoming':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
