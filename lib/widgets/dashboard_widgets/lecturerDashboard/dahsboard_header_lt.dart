import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DahsboardHeaderLt extends StatelessWidget {
  const DahsboardHeaderLt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lecturer Dashboard",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                Text(
                  "Manage Courses, exams and Student grades",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    color: AppColor.greyText,
                  ),
                ),
              ],
            ),
            Spacer(),
            GradientButtonLg(
              horizontalPadding: 20,
              verticalPadding: 20,
              onPressed: () {},
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.plus, color: AppColor.white, size: 16),
                  SizedBox(width: 3),
                  Text(
                    "Create Exam",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25),
            Icon(
              FontAwesomeIcons.solidBell,
              color: AppColor.greyText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
