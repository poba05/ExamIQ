import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';

class LecturerTimetable extends StatefulWidget {
  const LecturerTimetable({super.key});

  @override
  State<LecturerTimetable> createState() => _LecturerTimetableState();
}

class _LecturerTimetableState extends State<LecturerTimetable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopContainerLt(
          title: "Timetable",
          subtitle: "Welcome back, Mr Smith",
          onPressed: () {},
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Exam Schedule",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
