import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Upcomingcontainers extends StatelessWidget {
  const Upcomingcontainers({super.key});

  @override
  Widget build(BuildContext context) {
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
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Start Exam",
                          style: TextStyle(fontSize: 16, color: AppColor.white),
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
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            borderRadius: BorderRadius.circular(10),
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
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.3);
  }
}
