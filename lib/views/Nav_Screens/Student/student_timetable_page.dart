import 'package:examai/constants/app_color.dart';
import 'package:examai/data/timetable_list.dart';
import 'package:examai/widgets/special_widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentTimetablePage extends StatelessWidget {
  StudentTimetablePage({super.key});

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
                      'Exam Timetable',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'All your scheduled exams at a glance',
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
              // Quick info banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    SizedBox(width: 12),
                    Text(
                      'You have ${exams.length} exams scheduled this semester.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              SizedBox(height: 24),

              // Timetable table
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
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${exams.length} total',
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
                        Divider(height: 1),
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
                              rows: exams.asMap().entries.map((entry) {
                                final exam = entry.value;
                                final date = exam['date'] as DateTime;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        _formatDate(date),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        exam['time'] as String,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        exam['course'] as String,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          exam['type'] as String,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.primaryBlue,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        exam['duration'] as String,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    DataCell(
                                      Padding(
                                        padding: EdgeInsets.symmetric(
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
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.05, curve: Curves.easeOut),
            ],
          ),
        ),
      ],
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
