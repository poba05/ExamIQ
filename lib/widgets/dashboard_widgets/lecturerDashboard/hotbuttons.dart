import 'package:examai/data/lecturer_btn_data.dart';
import 'package:examai/widgets/buttons/lecturer_custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Hotbuttons extends StatelessWidget {
  const Hotbuttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: lecturerbtndata.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        return Expanded(
              child: LecturerCustomBtn(
                iconbg: data["Iconbg"] as Color,
                icon: data["Icon"] as IconData,
                boldText: data["Bold_text"] as String,
                text: data["Text"] as String,
                iconcolor: data["Iconcolor"] as Color,
                onTap: () {
                  (data["ontap"] as Function)(context);
                },
              ),
            )
            .animate()
            .fadeIn(delay: (400 + (index * 100)).ms, duration: 500.ms)
            .slideY(begin: 0.5);
      }).toList(),
    );
  }
}
