import 'package:examai/models/user_role.dart';
import 'package:examai/views/Login/login.dart';
import 'package:examai/widgets/buttons/basic_button.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/containers/gradient_container.dart';
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
      height: null,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 150,
          bottom: 100,
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Login(selectedRole: UserRole.student),
                              ),
                            );
                          },
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(
                                  selectedRole: UserRole.lecturer,
                                ),
                              ),
                            );
                          },
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
                    SizedBox(height: 40),
                    Row(
                      children: [
                        SizedBox(
                          child: Column(
                            children: [
                              Text(
                                "10K+",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Active Students",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        SizedBox(
                          child: Column(
                            children: [
                              Text(
                                "500+",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Lecturers",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        SizedBox(
                          child: Column(
                            children: [
                              Text(
                                "98%",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Accuracy",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 70),
            Container(
              height: 380,
              width: 550,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 70,
                    spreadRadius: 30,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset("lib/assets/exam_pic.jpg", fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
