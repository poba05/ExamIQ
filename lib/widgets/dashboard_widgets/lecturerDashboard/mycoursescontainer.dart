import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/views/popups/newcourse.dart';
import 'package:examai/widgets/containers/courses_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Mycoursescontainer extends StatelessWidget {
  const Mycoursescontainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              borderRadius: BorderRadius.circular(20),
              color: AppColor.white,
            ),
            child: Row(
              children: [
                Text(
                  "My Courses",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                Spacer(),
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    backgroundColor: AppColor.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.plus,
                        color: AppColor.white,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Add Course",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lecturerCourses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return CoursesContainer(
                  iconbackground: lecturerCourses[index]["iconbg"] as Color,
                  iconcolor: lecturerCourses[index]["iconcolor"] as Color,
                  icon: lecturerCourses[index]["mainicon"] as IconData,
                  title: lecturerCourses[index]["mainText"] as String,
                  description: lecturerCourses[index]["description"] as String,
                  students: lecturerCourses[index]["students"] as int,
                  exams: lecturerCourses[index]["exams"] as int,
                  average: lecturerCourses[index]["average"] as String,
                  subtitle: lecturerCourses[index]["subText"] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
