import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_summary_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SummaryCardlt extends StatelessWidget {
  const SummaryCardlt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // Dynamically generate summary cards from the `mylist` data.
      children: lecturersummary.asMap().entries.map((entry) {
        final index = entry.key;
        final items = entry.value;
        return Expanded(
              // Each card is a container with styling.
              child: Container(
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
                            color: items["iconbg"] as Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            items["icon"] as IconData,
                            color: items["icon_color"] as Color,
                            size: 20,
                          ),
                        ),
                        // Spacer to push the text to the right.
                        Spacer(),
                        Text(
                          items["color_text"] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: items["text_color"] as Color,
                          ),
                        ),
                      ],
                    ),
                    // End of Top row
                    SizedBox(height: 15),
                    // Main metric text (e.g., number of courses).
                    Text(
                      items["Bold_text"] as String,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Description text for the metric.
                    Text(
                      items["grey_text"] as String,
                      style: TextStyle(fontSize: 14, color: AppColor.greyText),
                    ),
                  ],
                ),
              ),
            )
            // Animate the card with a fade-in and slide-up effect.
            .animate()
            .fadeIn(delay: (200 + (index * 100)).ms, duration: 500.ms)
            .slideY(begin: 0.5);
      }).toList(),
    );
  }
}
