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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Create and Manage all your Exams",
                style: TextStyle(fontSize: 16, color: AppColor.greyText),
              ),
              GradientButtonLg(
                horizontalPadding: 20,
                verticalPadding: 15,
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.plus, size: 16, color: Colors.white),
                    SizedBox(width: 3),
                    Text(
                      "Create Exam",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                title: courses['coursetitle'] as String,
                subtitle: courses['coursecode'] as String,
                iconbg: courses['iconbg'] as Color,
                iconcolor: courses['iconcolor'] as Color,
                timeduration: courses['duration'] as int,
                noofquestions: courses['questions'] as int,
                noofstudents: courses['students'] as int,
                average: courses['average'] as String,
                submittedprogress: courses['submittedprogress'] as int,
                submittedtotal: courses['submittedtotal'] as int,
                gradedprogress: courses['Gradedprogress'] as int,
                gradedtotal: courses['Gradedtotal'] as int,
                gradedreview: courses['gradedreview'] as int,
                dateandtime: courses['dateandtime'] as String,
              ).animate().fadeIn(delay: (index * 200).ms).flipH();
            }).toList(),
          ),
        ),
      ],
    );
  }
}
