import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:examai/constants/app_color.dart';

class LecturerTimetable extends StatefulWidget {
  const LecturerTimetable({super.key});

  @override
  State<LecturerTimetable> createState() => _LecturerTimetableState();
}

class _LecturerTimetableState extends State<LecturerTimetable> {
  String _formatDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month]} ${dt.day}, ${dt.year}';
  }

  Color _statusColor(DateTime? dt) {
    if (dt == null) return Colors.grey;
    final now = DateTime.now();
    if (dt.isBefore(now)) return Colors.grey;
    final diff = dt.difference(now).inDays;
    if (diff <= 7) return Colors.orange;
    return Colors.green;
  }

  String _statusLabel(DateTime? dt) {
    if (dt == null) return 'Unknown';
    final now = DateTime.now();
    if (dt.isBefore(now)) return 'Completed';
    final diff = dt.difference(now).inDays;
    if (diff <= 7) return 'Soon';
    return 'Upcoming';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopContainerLt(
          title: 'Timetable',
          subtitle: 'View and manage all scheduled exams',
          buttonLabel: 'Schedule Exam',
          buttonIcon: FontAwesomeIcons.calendarPlus,
          onPressed: (ctx) {},
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                            'Exam Schedule',
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
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${lecturerCourses.length} exams scheduled',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryBlue,
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
                              minWidth: constraints.maxWidth > 900 ? constraints.maxWidth : 900,
                            ),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.grey.shade50,
                          ),
                          dataRowMinHeight: 60,
                          dataRowMaxHeight: 70,
                          columnSpacing: 32,
                          columns: [
                            DataColumn(
                              label: _header('COURSE'),
                            ),
                            DataColumn(
                              label: _header('CODE'),
                            ),
                            DataColumn(
                              label: _header('DATE'),
                            ),
                            DataColumn(
                              label: _header('TIME'),
                            ),
                            DataColumn(
                              label: _header('STUDENTS'),
                            ),
                            DataColumn(
                              label: _header('DURATION'),
                            ),
                            DataColumn(
                              label: _header('STATUS'),
                            ),
                            DataColumn(
                              label: _header('ACTIONS'),
                            ),
                          ],
                          rows: lecturerCourses.asMap().entries.map((entry) {
                            final item = entry.value;
                            final dt = item['date'] as DateTime?;
                            final sColor = _statusColor(dt);
                            final sLabel = _statusLabel(dt);

                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      Container(
                                        height: 38,
                                        width: 38,
                                        decoration: BoxDecoration(
                                          color: item['iconbg'] as Color,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          item['mainicon'] as IconData,
                                          color: item['iconcolor'] as Color,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        item['coursetitle']?.toString() ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['coursecode']?.toString() ?? '',
                                    style: TextStyle(
                                      color: AppColor.greyText,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    _formatDate(dt),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['time']?.toString() ?? '—',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.userGroup,
                                        size: 12,
                                        color: AppColor.greyText,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        item['students']?.toString() ?? '0',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item['duration'] ?? 0} min',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: sColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      sLabel,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: sColor,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          FontAwesomeIcons.solidEye,
                                          size: 14,
                                          color: AppColor.primaryBlue,
                                        ),
                                        tooltip: 'View',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 12),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          FontAwesomeIcons.penToSquare,
                                          size: 14,
                                          color: Colors.orange,
                                        ),
                                        tooltip: 'Edit',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
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
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05, curve: Curves.easeOut),
        ),
      ],
    );
  }

  Widget _header(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade600,
      ),
    );
  }
}
