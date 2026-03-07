import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.primaryBlue, AppColor.primaryPurple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Center(
                child: Icon(
                  FontAwesomeIcons.graduationCap,
                  color: AppColor.white,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              "ExamIQ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          "Smart exam management powered by artificial intelligence.",
          style: TextStyle(fontSize: 12, color: AppColor.white, height: 1.6),
        ),
      ],
    );
  }
}
