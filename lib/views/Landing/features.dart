import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/containers/list_container.dart';
import 'package:flutter/material.dart';

class Features extends StatefulWidget {
  static final my_list = [
    {
      "id": 1,
      "title": "Automated Grading",
      "description":
          "Save time and reduce errors with our AI-powered grading system.",
      "icon": Icons.auto_fix_high,
      "color1": Colors.blue,
      "color2": Colors.blue.shade100,
    },
    {
      "id": 2,
      "title": "Detailed Analytics",
      "description":
          "Gain insights into student performance with comprehensive analytics.",
      "icon": Icons.analytics,
      "color1": Colors.purple,
      "color2": Colors.purple.shade100,
    },
    {
      "id": 3,
      "title": "Customizable Exams",
      "description":
          "Create and customize exams to fit your specific needs and curriculum.",
      "icon": Icons.edit,
      "color1": Colors.orange,
      "color2": Colors.orange.shade100,
    },
    {
      "id": 4,
      "title": "Secure & Private",
      "description":
          "Ensure data security and privacy with our robust platform.",
      "icon": Icons.security,
      "color1": Colors.green,
      "color2": Colors.green.shade100,
    },
    {
      "id": 5,
      "title": "Customizable Exams",
      "description":
          "Create and customize exams to fit your specific needs and curriculum.",
      "icon": Icons.edit,
      "color1": Colors.orange,
      "color2": Colors.orange.shade100,
    },
    {
      "id": 6,
      "title": "Customizable Exams",
      "description":
          "Create and customize exams to fit your specific needs and curriculum.",
      "icon": Icons.edit,
      "color1": Colors.orange,
      "color2": Colors.orange.shade100,
    },
  ];
  const Features({super.key});

  @override
  State<Features> createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 70),
      width: double.infinity,
      color: AppColor.white,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          top: 100,
          bottom: 50,
        ),
        child: Column(
          children: [
            Text(
              "Powerful Features For Modern Education",
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Everything you need to manage exams efficiently",
              style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
            ),
            SizedBox(height: 80),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: Features.my_list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 1.55,
              ),
              itemBuilder: (context, index) {
                final item = Features.my_list[index];
                return ListContainer(
                  title: item["title"] as String,
                  description: item["description"] as String,
                  icon: item["icon"] as IconData,
                  color1: item["color1"] as Color,
                  color2: item["color2"] as Color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
