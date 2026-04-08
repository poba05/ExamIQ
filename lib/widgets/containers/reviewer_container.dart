import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';

class ReviewerContainer extends StatelessWidget {
  final int progress;
  final int total;
  final String text;
  final Color progressColor;
  const ReviewerContainer({
    super.key,
    required this.progress,
    required this.total,
    required this.text,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$progress/$total",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w100,
                color: AppColor.greyText,
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(
                begin: 0,
                end: total == 0 ? 0.0 : (progress / total).clamp(0.0, 1.0),
              ),
              duration: Duration(milliseconds: 500),
              builder: (context, value, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey.shade300,
                    color: progressColor,
                    minHeight: 6,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
