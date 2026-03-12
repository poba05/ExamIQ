import 'package:examai/constants/app_color.dart';
import 'package:examai/data/courses_data.dart';
import 'package:examai/data/lecturer_btn_data.dart';
import 'package:examai/data/lecturer_summary_list.dart';
import 'package:examai/data/student_summary_list.dart';
import 'package:examai/data/timetable_list.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/buttons/lecturer_custom_btn.dart';
import 'package:examai/widgets/special_widgets/exam_row.dart';
import 'package:examai/widgets/special_widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A widget that represents the main dashboard screen for a student.
///
/// It displays a summary of the student's activities, upcoming exams,
/// available courses, and an exam timetable.
class Dashboard extends StatefulWidget {
  final String userRole;
  const Dashboard({super.key, this.userRole = 'student'});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    // The main scrollable layout for the dashboard.
    return widget.userRole == 'student' ? StudentContent() : Lecturercontent();
  }
}

class StudentContent extends StatelessWidget {
  const StudentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header section of the dashboard.
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.white,
            // Bottom border for a clean separation.
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Main and sub-heading for the dashboard.
                  children: [
                    Text(
                      "Student Dashboard",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Text(
                      "Welcome back, John!",
                      style: TextStyle(fontSize: 14, color: AppColor.greyText),
                    ),
                  ],
                ),
                // Spacer to push the notification icon to the right.
                Spacer(),
                Icon(FontAwesomeIcons.bell, color: AppColor.greyText, size: 20),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        // Main content area of the dashboard with padding.
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Row of summary cards (Enrolled Courses, Active Exams, etc.).
              Row(
                // Dynamically generate summary cards from the `mylist` data.
                children: mylist.asMap().entries.map((entry) {
                  final index = entry.key;
                  final items = entry.value;
                  return Expanded(
                        // Each card is a container with styling.
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row of the card with icon and status text.
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: items["iconbg"] as Color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      items["icon"] as IconData,
                                      color: items["icon_color"] as Color,
                                      size: 20,
                                    ),
                                  ),
                                  // Spacer to push the text to the right.
                                  Spacer(),
                                  Text(
                                    items["color_text"] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: items["text_color"] as Color,
                                    ),
                                  ),
                                ],
                              ),
                              // End of Top row
                              SizedBox(height: 15),
                              // Main metric text (e.g., number of courses).
                              Text(
                                items["Bold_text"] as String,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Description text for the metric.
                              Text(
                                items["grey_text"] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.greyText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      // Animate the card with a fade-in and slide-up effect.
                      .animate()
                      .fadeIn(delay: (200 + (index * 100)).ms, duration: 500.ms)
                      .slideY(begin: 0.5);
                }).toList(),
              ),
              SizedBox(height: 20),
              // "Upcoming Exams" section.
              Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section header.
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Upcoming Exams",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        // First upcoming exam item.
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 25,
                              left: 20,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Exam icon with a colored background.
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.laptopCode,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      // Exam title and details.
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Data Structures Final Exam",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "CS201 • 60 minutes • 50 questions",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    // "Start Exam" button.
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.primaryBlue,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Start Exam",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // Row for additional details like date and proctor.
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.calendar,
                                      size: 15,
                                      color: AppColor.greyText,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Today 2:00pm",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.greyText,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      FontAwesomeIcons.user,
                                      color: AppColor.greyText,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Dr. Smith",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Second upcoming exam item.
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 25,
                              left: 20,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Exam icon with a colored background.
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.purple.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.database,
                                        color: Colors.purple,
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      // Exam title and details.
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Database Management midterm",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "CS301 • 90 minutes • 40 questions",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColor.greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    // "View details" button, styled differently for non-active exams.
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 20,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "View details",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColor.greyText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                // Row for additional details like date and proctor.
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.calendar,
                                      size: 15,
                                      color: AppColor.greyText,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Today 2:00pm",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.greyText,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      FontAwesomeIcons.user,
                                      color: AppColor.greyText,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Dr. Smith",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  // Animate the entire "Upcoming Exams" section.
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 500.ms)
                  .slideY(begin: 0.3),
              SizedBox(height: 20),
              Container(
                // "Available Courses" section.
                margin: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header for the "Available Courses" section.
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 5,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          children: [
                            // Section title.
                            Text(
                              "Available Courses",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            Spacer(),
                            // "View all" button to see more courses.
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "View all",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Row to display course cards.
                    Row(
                      // Dynamically generate course cards from the `courses` data.
                      children: courses.asMap().entries.map((entry) {
                        final index = entry.key;
                        final items = entry.value;
                        return Expanded(
                              child: Container(
                                // Styling for each course card.
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppColor.white,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  // Clip the content to the rounded border.
                                  borderRadius: BorderRadius.circular(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Course image.
                                      Image.asset(
                                        items["image"] as String,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(height: 5),
                                      // Padding for the text content below the image.
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Course title.
                                            Text(
                                              items["title"] as String,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.black,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            // Course details.
                                            Text(
                                              items["details"] as String,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.greyText,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              // Course code and "Apply" button.
                                              children: [
                                                Text(
                                                  items["course"] as String,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColor.greyText,
                                                  ),
                                                ),
                                                Spacer(),
                                                // Button to apply for the course.
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            AppColor
                                                                .primaryBlue,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 10,
                                                            ),
                                                      ),
                                                  child: Text(
                                                    "Apply",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColor.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            // Animate each course card with a fade-in and slide-up effect.
                            .animate()
                            .fadeIn(
                              delay: (800 + (index * 100)).ms,
                              duration: 500.ms,
                            )
                            .slideY(begin: 0.5);
                      }).toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(begin: 0.1),
              SizedBox(height: 20),
              Container(
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
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
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
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
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
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                              ),
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
                  // Animate the entire "Exam Timetable" section.
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 500.ms)
                  .slideY(begin: 0.2),
            ],
          ),
        ),
      ],
      // Animate the entire dashboard content on load.
    ).animate().fadeIn(duration: 200.ms);
  }
}

class Lecturercontent extends StatelessWidget {
  const Lecturercontent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lecturer Dashboard",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Text(
                      "Manage Courses, exams and Student grades",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w100,
                        color: AppColor.greyText,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GradientButtonLg(
                  horizontalPadding: 20,
                  verticalPadding: 20,
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.plus,
                        color: AppColor.white,
                        size: 16,
                      ),
                      SizedBox(width: 3),
                      Text(
                        "Create Exam",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
                Icon(
                  FontAwesomeIcons.solidBell,
                  color: AppColor.greyText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        // Main content area of the dashboard with padding.
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Row of summary cards (Enrolled Courses, Active Exams, etc.).
              Row(
                // Dynamically generate summary cards from the `mylist` data.
                children: lecturersummary.asMap().entries.map((entry) {
                  final index = entry.key;
                  final items = entry.value;
                  return Expanded(
                        // Each card is a container with styling.
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row of the card with icon and status text.
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: items["iconbg"] as Color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      items["icon"] as IconData,
                                      color: items["icon_color"] as Color,
                                      size: 20,
                                    ),
                                  ),
                                  // Spacer to push the text to the right.
                                  Spacer(),
                                  Text(
                                    items["color_text"] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: items["text_color"] as Color,
                                    ),
                                  ),
                                ],
                              ),
                              // End of Top row
                              SizedBox(height: 15),
                              // Main metric text (e.g., number of courses).
                              Text(
                                items["Bold_text"] as String,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Description text for the metric.
                              Text(
                                items["grey_text"] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.greyText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      // Animate the card with a fade-in and slide-up effect.
                      .animate()
                      .fadeIn(delay: (200 + (index * 100)).ms, duration: 500.ms)
                      .slideY(begin: 0.5);
                }).toList(),
              ),
              SizedBox(height: 5),
              Row(
                children: lecturerbtndata.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return Expanded(
                        child: LecturerCustomBtn(
                          iconbg: data["Iconbg"] as Color,
                          icon: data["Icon"] as IconData,
                          boldText: data["Bold_text"] as String,
                          text: data["Text"] as String,
                          iconcolor: data["Iconcolor"] as Color,
                          onTap: () {},
                        ),
                      )
                      .animate()
                      .fadeIn(delay: (400 + (index * 100)).ms, duration: 500.ms)
                      .slideY(begin: 0.5);
                }).toList(),
              ),
              SizedBox(height: 20),
              Container(
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
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pending Grade Reviews",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.black,
                                  ),
                                ),
                                Text(
                                  "AI-graded exams awaiting your approval",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.greyText,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "12 pending",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
