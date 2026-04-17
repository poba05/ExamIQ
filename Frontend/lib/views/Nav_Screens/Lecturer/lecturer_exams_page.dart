import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/containers/lecturer_exam_cont.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LecturerExamsPage extends StatefulWidget {
  const LecturerExamsPage({super.key});

  @override
  State<LecturerExamsPage> createState() => _LecturerExamsPageState();
}

class _LecturerExamsPageState extends State<LecturerExamsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopContainerLt(
          title: "Exams",
          subtitle: "Welcome back, dr.smith",
          onPressed: () {},
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Create and Manage all your Exams",
                  style: TextStyle(fontSize: 14, color: AppColor.greyText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              GradientButtonLg(
                horizontalPadding: 24,
                verticalPadding: 12,
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(FontAwesomeIcons.plus, size: 14, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Create Exam",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: lecturerCourses.asMap().entries.map((entry) {
              final index = entry.key;
              final courses = entry.value;
              return LecturerExamCont(
                    title: courses['coursetitle']?.toString() ?? "N/A",
                    subtitle: courses['coursecode']?.toString() ?? "",
                    iconbg: courses['iconbg'] is Color
                        ? courses['iconbg'] as Color
                        : Colors.grey.shade100,
                    iconcolor: courses['iconcolor'] is Color
                        ? courses['iconcolor'] as Color
                        : Colors.grey,
                    timeduration: (courses['duration'] as num?)?.toInt() ?? 0,
                    noofquestions: (courses['questions'] as num?)?.toInt() ?? 0,
                    noofstudents: (courses['students'] as num?)?.toInt() ?? 0,
                    average: courses['average']?.toString() ?? "0%",
                    submittedprogress:
                        (courses['submittedprogress'] as num?)?.toInt() ?? 0,
                    submittedtotal:
                        (courses['submittedtotal'] as num?)?.toInt() ?? 0,
                    gradedprogress:
                        (courses['Gradedprogress'] as num?)?.toInt() ?? 0,
                    gradedtotal: (courses['Gradedtotal'] as num?)?.toInt() ?? 0,
                    gradedreview:
                        (courses['gradedreview'] as num?)?.toInt() ?? 0,
                    dateandtime: courses['dateandtime']?.toString() ?? "",
                  )
                  .animate()
                  .fadeIn(delay: (index * 200).ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
