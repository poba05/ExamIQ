import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/widgets/containers/list_container.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LecturerReviewPage extends StatelessWidget {
  static final list = [
    {
      "id": 1,
      "maintext": "12",
      "Subtext": "Pending Reviews",
      "icon": FontAwesomeIcons.solidHourglassHalf,
      "iconColor": Colors.orange,
      "iconbg": Colors.orange.shade100,
      "bgcolor": AppColor.white,
    },
    {
      "id": 2,
      "maintext": "156",
      "Subtext": "Approved Grades",
      "icon": FontAwesomeIcons.solidCircleCheck,
      "iconColor": Colors.green,
      "iconbg": Colors.green.shade100,
      "bgcolor": AppColor.white,
    },
    {
      "id": 3,
      "maintext": "96%",
      "Subtext": "AI Accuracy",
      "icon": FontAwesomeIcons.robot,
      "iconColor": Colors.blue,
      "iconbg": Colors.blue.shade100,
      "bgcolor": AppColor.white,
    },
  ];
  const LecturerReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopContainerLt(
          title: "Review Grades",
          subtitle: "Review and manage student grades",
          onPressed: () {
            // Handle back button press
          },
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1.72,
                ),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: item["bgcolor"] as Color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: item["iconbg"] as Color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              item["icon"] as IconData,
                              color: item["iconColor"] as Color,
                              size: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            item["maintext"] as String,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            item["Subtext"] as String,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (index * 100).ms).flipH();
                },
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        top: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Exams Awaiting Review",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColor.black,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                "12 pending",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: lecturerCourses.asMap().entries.map((entry) {
                        final index = entry.key;
                        final course = entry.value;
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade100,
                                width: 1,
                              ),
                              top: BorderSide(
                                color: Colors.grey.shade100,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: course["iconbg"] as Color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.clipboardCheck,
                                      color: course["iconcolor"] as Color,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course["coursetitle"] as String,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "${course["coursecode"]} • ${course["Gradedprogress"]} students graded",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.greyText,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          "AI confidence: ${course["ai_confidence"]}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Avg: ${course["average"]}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.normal,
                                            color: AppColor.greyText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.solidEye,
                                        color: AppColor.white,
                                        size: 14,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Review",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.check,
                                        color: AppColor.white,
                                        size: 14,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Approve",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: (index * 200).ms).flipH();
                      }).toList(),
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
