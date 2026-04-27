import 'package:examai/constants/app_color.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:examai/widgets/special_widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentTimetablePage extends StatefulWidget {
  const StudentTimetablePage({super.key});

  @override
  State<StudentTimetablePage> createState() => _StudentTimetablePageState();
}

class _StudentTimetablePageState extends State<StudentTimetablePage> {
  final SupabaseService _supabaseService = SupabaseService();

  String _formatDate(DateTime dt) {
    const months = [
      '',
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = [
      '', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];
    return '${days[dt.weekday]}, ${months[dt.month]} ${dt.day}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _supabaseService.getAllExams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Map<String, dynamic>> rawExams = snapshot.data ?? [];

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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Exam Timetable',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'All your scheduled exams at a glance',
                          style: TextStyle(fontSize: 14, color: AppColor.greyText),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(FontAwesomeIcons.solidBell, color: AppColor.greyText, size: 20),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.primaryBlue.withOpacity(0.08),
                          AppColor.primaryPurple.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColor.primaryBlue.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.circleInfo,
                          color: AppColor.primaryBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'You have ${rawExams.length} exams scheduled this semester.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // Timetable table
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Schedule',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.black,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${rawExams.length} total',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primaryPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
                                ),
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                    Colors.grey.shade50,
                                  ),
                                  dataRowMinHeight: 64,
                                  dataRowMaxHeight: 72,
                                  columnSpacing: 28,
                                  columns: [
                                    _col('DATE'),
                                    _col('TIME'),
                                    _col('COURSE'),
                                    _col('TYPE'),
                                    _col('DURATION'),
                                    _col('STATUS'),
                                  ],
                                  rows: rawExams.asMap().entries.map((entry) {
                                    final exam = entry.value;
                                    final dateStr = exam['exam_date'] as String? ?? '';
                                    final date = DateTime.tryParse(dateStr) ?? DateTime.now();
                                    final course = exam['courses'] as Map? ?? {};
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            _formatDate(date),
                                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            exam['start_time']?.toString() ?? 'TBD',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        DataCell(
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                course['title']?.toString() ?? 'Untitled Exam',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                              Text(
                                                course['course_code']?.toString() ?? 'N/A',
                                                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const DataCell(
                                          Text(
                                            'Final Exam',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            '${exam['duration_minutes'] ?? 0} min',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                        DataCell(
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: statusBadge(date),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.05, curve: Curves.easeOut),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  DataColumn _col(String label) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
