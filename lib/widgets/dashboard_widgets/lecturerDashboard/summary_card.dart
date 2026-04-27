import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_summary_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SummaryCardlt extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const SummaryCardlt({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      // Dynamically generate summary cards from the provided items.
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Expanded(
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
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: item["iconbg"] as Color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        item["icon"] as IconData,
                        color: item["icon_color"] as Color,
                        size: 20,
                      ),
                    ),
                    Spacer(),
                    Text(
                      item["color_text"] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: item["text_color"] as Color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  item["Bold_text"] as String,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  item["grey_text"] as String,
                  style: TextStyle(fontSize: 14, color: AppColor.greyText),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (200 + (index * 100)).ms, duration: 500.ms)
        .slideY(begin: 0.5);
      }).toList(),
    );
  }
}
