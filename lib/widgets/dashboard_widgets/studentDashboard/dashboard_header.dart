import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white,
        // Bottom border for a clean separation.
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Main and sub-heading for the dashboard.
              children: [
                Text(
                  "Student Dashboard",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                Text(
                  "Welcome back, John!",
                  style: TextStyle(fontSize: 14, color: AppColor.greyText),
                ),
              ],
            ),
            // Spacer to push the notification icon to the right.
            Spacer(),
            Icon(FontAwesomeIcons.bell, color: AppColor.greyText, size: 20),
          ],
        ),
      ),
    );
  }
}
