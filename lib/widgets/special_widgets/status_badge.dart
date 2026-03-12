import 'package:flutter/material.dart';

Widget statusBadge(DateTime examDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final examDay = DateTime(examDate.year, examDate.month, examDate.day);

  String text;
  Color color;

  if (examDay.isBefore(today)) {
    text = "Past";
    color = Colors.grey;
  } else if (examDay == today) {
    text = "Today";
    color = Colors.green;
  } else {
    text = "Upcoming";
    color = Colors.blue;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.w500),
    ),
  );
}
