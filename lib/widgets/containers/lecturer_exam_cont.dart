import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/buttons/basic_button.dart';
import 'package:examai/widgets/containers/reviewer_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LecturerExamCont extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color iconcolor;
  final Color iconbg;
  final int noofquestions;
  final int noofstudents;
  final int timeduration;
  final String average;
  final int submittedprogress;
  final int submittedtotal;
  final int gradedprogress;
  final int gradedtotal;
  final int gradedreview;
  final String dateandtime;
  const LecturerExamCont({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconcolor,
    required this.iconbg,
    required this.timeduration,
    required this.noofquestions,
    required this.noofstudents,
    required this.average,
    required this.submittedprogress,
    required this.submittedtotal,
    required this.gradedprogress,
    required this.gradedtotal,
    required this.gradedreview,
    required this.dateandtime,
  });

  @override
  State<LecturerExamCont> createState() => _LecturerExamContState();
}

class _LecturerExamContState extends State<LecturerExamCont> {
  bool ishovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => ishovering = true),
      onExit: (_) => setState(() => ishovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        // Using translationValues is safer for interpolation
        transform: Matrix4.translationValues(0, ishovering ? -6 : 0, 0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 2, right: 2),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ishovering
                  ? AppColor.primaryBlue.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              spreadRadius: ishovering ? 4 : 1,
              blurRadius: ishovering ? 15 : 5,
              offset: ishovering
                  ? const Offset(0, 10)
                  : const Offset(0, 3), // Deeper shadow when raised
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: widget.iconbg,
                    ),
                    child: Icon(
                      FontAwesomeIcons.clipboardList,
                      color: widget.iconcolor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.subtitle} • ${widget.dateandtime}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.greyText,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.solidClock,
                            size: 12,
                            color: AppColor.greyText,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.timeduration} min",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColor.greyText,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            FontAwesomeIcons.circleQuestion,
                            size: 12,
                            color: AppColor.greyText,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.noofquestions} questions",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColor.greyText,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            FontAwesomeIcons.users,
                            size: 12,
                            color: AppColor.greyText,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${widget.noofstudents} students",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColor.greyText,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            FontAwesomeIcons.chartLine,
                            size: 14,
                            color: AppColor.greyText,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.average} average",
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColor.greyText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 20,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Graded",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  BasicButton(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    onPressed: () {},
                    child: const Text(
                      "Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ReviewerContainer(
                      progress: widget.submittedprogress,
                      total: widget.submittedtotal,
                      text: "submitted",
                      progressColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ReviewerContainer(
                      progress: widget.gradedprogress,
                      total: widget.gradedtotal,
                      text: "Graded",
                      progressColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ReviewerContainer(
                      progress: widget.gradedreview,
                      total: widget.submittedtotal,
                      text: "Pending review",
                      progressColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
