import 'package:examai/constants/app_color.dart';
import 'package:examai/data/timetable_list.dart';
import 'package:examai/widgets/special_widgets/status_badge.dart';
import 'package:examai/widgets/special_widgets/table/exam_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:examai/utils/supabase_service.dart';

class Examtimetable extends StatelessWidget {
  const Examtimetable({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseService _db = SupabaseService();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _db.getAllExams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final exams = snapshot.data ?? [];

        return Container(
          margin: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 40,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Text(
                    "Exam Timetable",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                ),
              ),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    children: [
                      _headerCell("Date"),
                      _headerCell("Time"),
                      _headerCell("Course"),
                      _headerCell("Type"),
                      _headerCell("Duration"),
                      _headerCell("Status"),
                    ],
                  ),
                  for (var exam in exams)
                    TableRow(
                      children: [
                        _dataCell(exam["exam_date"]?.toString() ?? "TBD"),
                        _dataCell(exam["start_time"]?.toString() ?? "TBD"),
                        _dataCell(
                          (exam['courses'] as Map?)?['title']?.toString() ?? "N/A",
                          isBold: true,
                        ),
                        _dataCell("Exam"), // Placeholder
                        _dataCell("${exam["duration_minutes"] ?? 0} min"),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 28.0,
                            ),
                            child: statusBadge(
                              DateTime.tryParse(exam["exam_date"]?.toString() ?? "") ?? DateTime.now(),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideY(begin: 0.1);
      },
    );
  }

  Widget _headerCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Text(
          text,
          style: TextStyle(
            color: AppColor.greyText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _dataCell(String text, {bool isBold = false}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
