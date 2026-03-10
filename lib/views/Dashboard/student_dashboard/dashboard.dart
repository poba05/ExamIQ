import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final my_list = [
    {
      "id": 1,
      "icon": FontAwesomeIcons.book,
      "iconbg": Colors.blue.shade100,
      "icon_color": Colors.blue,
      "text_color": Colors.green,
      "Bold_text": "8",
      "grey_text": "Enrolled Courses",
      "color_text": "+2 new",
    },
    {
      "id": 2,
      "icon": FontAwesomeIcons.clipboardCheck,
      "iconbg": Colors.purple.shade100,
      "icon_color": Colors.purple,
      "text_color": Colors.red,
      "Bold_text": "12",
      "grey_text": "Completed Exams",
      "color_text": "3 pending",
    },
    {
      "id": 3,
      "icon": FontAwesomeIcons.star,
      "iconbg": Colors.green.shade100,
      "icon_color": Colors.green,
      "text_color": Colors.green,
      "Bold_text": "85%",
      "grey_text": "Average Grade",
      "color_text": "+5%",
    },
    {
      "id": 4,
      "icon": FontAwesomeIcons.clock,
      "iconbg": Colors.orange.shade100,
      "icon_color": Colors.orange,
      "text_color": Colors.blue,
      "Bold_text": "5",
      "grey_text": "Upcoming Exams",
      "color_text": "2 today",
    },
  ];

  final courses = [
    {
      "id": 1,
      "image": "lib/assets/course1.jpg",
      "title": "Machine Learning Basics",
      "details": "Introduction to ML algorithms and applications",
      "course": "CS401",
    },
    {
      "id": 2,
      "image": "lib/assets/course2.jpg",
      "title": "Web Development",
      "details": "Full-stack web development with modern tools",
      "course": "CS302",
    },
    {
      "id": 3,
      "image": "lib/assets/course3.jpg",
      "title": "Cybersecurity Fundamentals",
      "details": "Network security and ethical hacking basics",
      "course": "CS502",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.white,
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
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.greyText,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    FontAwesomeIcons.bell,
                    color: AppColor.greyText,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: my_list.asMap().entries.map((entry) {
                    final index = entry.key;
                    final items = entry.value;
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
                                //Top Row
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
                                //End of Top row
                                SizedBox(height: 15),
                                Text(
                                  items["Bold_text"] as String,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  items["grey_text"] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.greyText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(
                          delay: (200 + (index * 100)).ms,
                          duration: 500.ms,
                        )
                        .slideY(begin: 0.5);
                  }).toList(),
                ),
                SizedBox(height: 20),
                Container(
                      margin: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Upcoming Exams",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 25,
                                left: 20,
                                right: 20,
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
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.laptopCode,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Data Structures Final Exam",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "CS201 • 60 minutes • 50 questions",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.greyText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.primaryBlue,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 20,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Start Exam",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.calendar,
                                        size: 15,
                                        color: AppColor.greyText,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Today 2:00pm",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.greyText,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        FontAwesomeIcons.user,
                                        color: AppColor.greyText,
                                        size: 15,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Dr. Smith",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 25,
                                left: 20,
                                right: 20,
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
                                          color: Colors.purple.shade100,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.database,
                                          color: Colors.purple,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Database Management midterm",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "CS301 • 90 minutes • 40 questions",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.greyText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade300,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 20,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "View details",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor.greyText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.calendar,
                                        size: 15,
                                        color: AppColor.greyText,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Today 2:00pm",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.greyText,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        FontAwesomeIcons.user,
                                        color: AppColor.greyText,
                                        size: 15,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Dr. Smith",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.greyText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 500.ms)
                    .slideY(begin: 0.3),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 5,
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Available Courses",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.black,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "View all",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: courses.asMap().entries.map((entry) {
                          final index = entry.key;
                          final items = entry.value;
                          return Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          items["image"] as String,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(height: 5),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                items["title"] as String,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.black,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                items["details"] as String,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColor.greyText,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    items["course"] as String,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColor.greyText,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColor.primaryBlue,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 10,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "Apply",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColor.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(
                                delay: (800 + (index * 100)).ms,
                                duration: 500.ms,
                              )
                              .slideY(begin: 0.5);
                        }).toList(),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(begin: 0.3),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(duration: 200.ms),
    );
  }
}
