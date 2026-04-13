import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/views/popups/newcourse.dart';
import 'package:examai/widgets/containers/courses_container.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LecturerCourses extends StatefulWidget {
  const LecturerCourses({super.key});

  @override
  State<LecturerCourses> createState() => _LecturerCoursesState();
}

class _LecturerCoursesState extends State<LecturerCourses> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TopContainerLt(
          title: "Courses",
          subtitle: "Welcome back, Mr. Smith",
          buttonLabel: "Create Course",
          buttonIcon: FontAwesomeIcons.plus,
          onPressed: (context) {
            showDialog(
              context: context,
              builder: (context) => const Dialog(
                backgroundColor: Colors.transparent,
                child: Newcourse(),
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Manage your courses and students enrollment",
                      style: TextStyle(fontSize: 14, color: AppColor.greyText),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const Dialog(
                          backgroundColor: Colors.transparent,
                          child: Newcourse(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryBlue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.plus,
                          size: 16,
                          color: AppColor.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Create Course",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              GridView.builder(
                itemCount: lecturerCourses.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  return CoursesContainer(
                        iconbackground:
                            lecturerCourses[index]["iconbg"] as Color,
                        iconcolor: lecturerCourses[index]["iconcolor"] as Color,
                        icon: lecturerCourses[index]["mainicon"] as IconData,
                        title: lecturerCourses[index]["coursetitle"] as String,
                        subtitle:
                            lecturerCourses[index]["coursecode"] as String,
                        description:
                            lecturerCourses[index]["description"] as String,
                        students: lecturerCourses[index]["students"] as int,
                        exams: lecturerCourses[index]["exams"] as int,
                        average: lecturerCourses[index]["average"] as String,
                      )
                      .animate()
                      .fadeIn(delay: (index * 200).ms)
                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
