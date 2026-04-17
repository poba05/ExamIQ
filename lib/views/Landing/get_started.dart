import 'package:examai/constants/app_color.dart';
import 'package:examai/views/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.primaryBlue, // blue
            AppColor.primaryPurple,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Ready to Transform Your Exam Management?",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColor.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Join thousands of students and lecturers already using ExamAI",
            style: TextStyle(fontSize: 22, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(selectedRole: null),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryBlue,
                  ),
                ),
                SizedBox(width: 20),
                Icon(FontAwesomeIcons.arrowRight, color: Color(0xFF3B82F6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
