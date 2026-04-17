import 'package:examai/widgets/special_widgets/status_badge.dart';
import 'package:flutter/material.dart';

Widget examRow(Map exam) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formatDate(exam["date"])),

        Text(exam["time"]),

        Text(
          exam["course"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        Text(exam["type"]),

        Text(exam["duration"]),

        statusBadge(exam["date"]),
      ],
    ),
  );
}

String formatDate(DateTime date) {
  return "${date.month}/${date.day}/${date.year}";
}
