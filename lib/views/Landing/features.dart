import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/containers/list_container.dart';
import 'package:flutter/material.dart';

class Features extends StatefulWidget {
  static final my_list = [
    {
      "id": 1,
      "title": "Automated Grading",
      "description":
          "Save time and reduce errors with our AI-powered grading system that grades in seconds.",
      "icon": Icons.auto_fix_high,
      "color1": Colors.blue,
    },
    {
      "id": 2,
      "title": "Detailed Analytics",
      "description":
          "Gain deep insights into student performance with comprehensive charts and reports.",
      "icon": Icons.analytics,
      "color1": Colors.purple,
    },
    {
      "id": 3,
      "title": "Customizable Exams",
      "description":
          "Create multi-format exams — MCQ, short answer, essays — tailored to your curriculum.",
      "icon": Icons.edit_note,
      "color1": Colors.orange,
    },
    {
      "id": 4,
      "title": "Secure & Private",
      "description":
          "Bank-level encryption and role-based access keep your data fully protected.",
      "icon": Icons.security,
      "color1": Colors.green,
    },
    {
      "id": 5,
      "title": "Real-Time Monitoring",
      "description":
          "Track live exam progress, flag anomalies, and monitor student activity in real time.",
      "icon": Icons.monitor_heart,
      "color1": Colors.teal,
    },
    {
      "id": 6,
      "title": "Instant Feedback",
      "description":
          "Students receive detailed AI-generated feedback on their answers immediately after submission.",
      "icon": Icons.feedback,
      "color1": Colors.indigo,
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
                final iconColor = item["color1"] as Color;
                return ListContainer(
                  title: item["title"] as String,
                  description: item["description"] as String,
                  icon: item["icon"] as IconData,
                  iconbg: iconColor,
                  iconcolor: AppColor.white,
                  backgroundColor: AppColor.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
