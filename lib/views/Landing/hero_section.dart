import 'package:examai/widgets/buttons/basic_button.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/gradient_container.dart';
import 'package:examai/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      height: 700,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 100,
          top: 120,
          bottom: 100,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.blue.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.wandMagicSparkles,
                        color: Colors.blue,
                        size: 15,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Ai powered Grading",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Smart Exam",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    Text(
                      "Management Made",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    GradientText(text: "Simple", fontSize: 70, height: 1.0),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "Take exams online, grade with AI, scan handwritten papers,\n"
                  "and manage courses all in one powerful platform.",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 20,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    GradientButtonLg(
                      horizontalPadding: 50,
                      verticalPadding: 30,
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.userGraduate,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Student",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    BasicButton(
                      horizontalPadding: 30,
                      verticalPadding: 30,
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.chalkboardUser,
                            color: Colors.black,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Lecturer Portal",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
