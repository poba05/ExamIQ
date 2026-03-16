import 'package:examai/views/popups/newcourse.dart';
import 'package:examai/views/popups/newexam.dart';
import 'package:examai/views/popups/scanfile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final lecturerbtndata = [
  {
    "id": 1,
    "Iconbg": Colors.blue.shade100,
    "Iconcolor": Colors.blue,
    "Icon": FontAwesomeIcons.plus,
    "Bold_text": "Create Course",
    "Text": "Create a new course",
    "ontap": (context) {
      showDialog(
        context: context,
        builder: (context) => const Dialog(
          backgroundColor: Colors.transparent,
          child: Newcourse(),
        ),
      );
    },
  },
  {
    "id": 2,
    "Iconbg": Colors.purple.shade100,
    "Iconcolor": Colors.purple,
    "Icon": FontAwesomeIcons.solidFile,
    "Bold_text": "New Exam",
    "Text": "Create Exam Questions",
    "ontap": (context) {
      showDialog(
        context: context,
        builder: (context) =>
            const Dialog(backgroundColor: Colors.transparent, child: Newexam()),
      );
    },
  },
  {
    "id": 3,
    "Iconbg": Colors.green.shade100,
    "Iconcolor": Colors.green,
    "Icon": FontAwesomeIcons.magnifyingGlass,
    "Bold_text": "Scan Papers",
    "Text": "Upload handwritten exams",
    "ontap": (context) {
      showDialog(
        context: context,
        builder: (context) => const Dialog(
          backgroundColor: Colors.transparent,
          child: Scanfile(),
        ),
      );
    },
  },
  {
    "id": 4,
    "Iconbg": Colors.orange.shade100,
    "Iconcolor": Colors.orange,
    "Icon": FontAwesomeIcons.checkDouble,
    "Bold_text": "Review Grades",
    "Text": "Proofread Ai grading",
    "ontap": (context) {
      showDialog(
        context: context,
        builder: (context) =>
            const Dialog(backgroundColor: Colors.transparent, child: Newexam()),
      );
    },
  },
];
