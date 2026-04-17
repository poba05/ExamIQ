import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';

class Footercolumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const Footercolumn({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.white,
          ),
        ),
        SizedBox(height: 10),
        ...items.map(
          (items) => Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              items,
              style: TextStyle(color: AppColor.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
