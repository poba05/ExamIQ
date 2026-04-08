import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopContainerLt extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPressed;
  const TopContainerLt({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
        color: AppColor.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: AppColor.greyText),
                ),
              ],
            ),
            Spacer(),
            GradientButtonLg(
              horizontalPadding: 20,
              verticalPadding: 20,
              onPressed: () => onPressed(context),
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
            SizedBox(width: 5),
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
