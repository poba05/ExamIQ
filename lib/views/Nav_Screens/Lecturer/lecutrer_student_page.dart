import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:examai/widgets/special_widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LecutrerStudentPage extends StatefulWidget {
  static final sumlist = [
    {
      "id": 1,
      "icon": FontAwesomeIcons.users,
      "maintext": "248",
      "subtext": "Total Students",
      "iconbg": Colors.blue.shade100,
      "iconcolor": Colors.blue,
    },
    {
      "id": 2,
      "icon": FontAwesomeIcons.userCheck,
      "maintext": "201",
      "subtext": "Active Students",
      "iconbg": Colors.green.shade100,
      "iconcolor": Colors.green,
    },
    {
      "id": 3,
      "icon": FontAwesomeIcons.solidStar,
      "maintext": "3.6",
      "subtext": "Average GPA",
      "iconbg": Colors.purple.shade100,
      "iconcolor": Colors.purple,
    },
    {
      "id": 4,
      "icon": FontAwesomeIcons.solidClock,
      "maintext": "18",
      "subtext": "Pending Enrollment",
      "iconbg": Colors.orange.shade100,
      "iconcolor": Colors.orange,
    },
  ];
  const LecutrerStudentPage({super.key});

  @override
  State<LecutrerStudentPage> createState() => _LecutrerStudentPageState();
}

class _LecutrerStudentPageState extends State<LecutrerStudentPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopContainerLt(
          title: "Students",
          subtitle: "Welcome back, Mr Smith",
          onPressed: () {},
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: LecutrerStudentPage.sumlist.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1.45,
                ),
                itemBuilder: (context, index) {
                  final item = LecutrerStudentPage.sumlist[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: item["iconbg"] as Color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              item["icon"] as IconData,
                              color: item["iconcolor"] as Color,
                              size: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            item["maintext"] as String,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            item["subtext"] as String,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (index * 100).ms).flipH();
                },
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            "All Students",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColor.black,
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 250,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                prefixIcon: Icon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  size: 16,
                                  color: AppColor.greyText,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 160,
                            child: Dropdown(
                              mylist: [
                                "All status",
                                "Active",
                                "Inactive",
                                "Pending",
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
