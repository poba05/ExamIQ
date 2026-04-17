import 'package:examai/constants/app_color.dart';
import 'package:examai/data/timetable_list.dart';
import 'package:examai/widgets/special_widgets/status_badge.dart';
import 'package:examai/widgets/special_widgets/table/exam_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Examtimetable extends StatelessWidget {
  const Examtimetable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          // "Exam Timetable" section.
          margin: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header for the timetable.
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
              // A `Table` widget for a structured and aligned layout of the timetable.
              Table(
                // Define the relative widths of the columns.
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(3),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                // Add horizontal borders between rows.
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                children: [
                  // The header row of the table.
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    children: [
                      // Each `TableCell` represents a header cell.
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 20.0,
                          ),
                          child: Text(
                            "Date",
                            style: TextStyle(
                              color: AppColor.greyText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 5.0,
                          ),
                          child: Text(
                            "Time",
                            style: TextStyle(
                              color: AppColor.greyText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 5.0,
                          ),
                          child: Text(
                            "Course",
                            style: TextStyle(
                              color: AppColor.greyText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 5.0,
                          ),
                          child: Text(
                            "Type",
                            style: TextStyle(
                              color: AppColor.greyText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 5.0,
                          ),
                          child: Text(
                            "Duration",
                            style: TextStyle(
                              color: AppColor.greyText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 5.0,
                          ),
                          child: Text(
                            "Status",
                            style: TextStyle(
                              color: AppColor.greyText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Dynamically generate a `TableRow` for each exam in the `exams` list.
                  for (var exam in exams)
                    TableRow(
                      children: [
                        // Each `TableCell` contains data for one exam property.
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20.0,
                            ),
                            child: Text(
                              // Use a helper function to format the date.
                              formatDate(exam["date"] as DateTime),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5.0,
                            ),
                            child: Text(exam["time"] as String),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5.0,
                            ),
                            child: Text(
                              exam["course"] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5.0,
                            ),
                            child: Text(exam["type"] as String),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5.0,
                            ),
                            child: Text(exam["duration"] as String),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 28.0,
                            ),
                            child: statusBadge(
                              // Use the custom `statusBadge` widget to display the exam status.
                              exam["date"] as DateTime,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        )
        .animate()
        // Animate the entire "Exam Timetable" section.
        .animate()
        .fadeIn(delay: 900.ms, duration: 500.ms)
        .slideY(begin: 0.2);
  }
}
