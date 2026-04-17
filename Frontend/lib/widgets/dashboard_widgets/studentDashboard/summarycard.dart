import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';

class Summarycard extends StatelessWidget {
  final Color iconbg;
  final IconData icon;
  final Color iconcolor;
  final String colortext;
  final String boldtext;
  final String greytext;
  final Color textcolor;

  const Summarycard({
    super.key,
    required this.iconbg,
    required this.icon,
    required this.iconcolor,
    required this.colortext,
    required this.boldtext,
    required this.greytext,
    required this.textcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row of the card with icon and status text.
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: iconbg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconcolor, size: 20),
              ),
              // Spacer to push the text to the right.
              Spacer(),
              Text(
                colortext,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                ),
              ),
            ],
          ),
          // End of Top row
          SizedBox(height: 15),
          // Main metric text (e.g., number of courses).
          Text(
            boldtext,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          SizedBox(height: 10),
          // Description text for the metric.
          Text(
            greytext,
            style: TextStyle(fontSize: 14, color: AppColor.greyText),
          ),
        ],
      ),
    );
  }
}
