import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/views/popups/newcourse.dart';
import 'package:examai/widgets/containers/courses_container.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:examai/views/Nav_Screens/Lecturer/manage_course.dart';

class LecturerCourses extends StatefulWidget {
  const LecturerCourses({super.key});

  @override
  State<LecturerCourses> createState() => _LecturerCoursesState();
}

class _LecturerCoursesState extends State<LecturerCourses> {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _supabaseService.getLecturerCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<Map<String, dynamic>> courses = snapshot.data ?? [];

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopContainerLt(
              title: "Courses",
              subtitle: "Manage your courses effectively",
              buttonLabel: "Create Course",
              buttonIcon: FontAwesomeIcons.plus,
              onPressed: (context) async {
                final result = await showDialog(
                  context: context,
                  builder: (context) => const Dialog(
                    backgroundColor: Colors.transparent,
                    child: Newcourse(),
                  ),
                );
                if (result == true) {
                  setState(() {});
                }
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
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.greyText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) => const Dialog(
                              backgroundColor: Colors.transparent,
                              child: Newcourse(),
                            ),
                          );
                          if (result == true) {
                            setState(() {});
                          }
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
                  courses.isEmpty
                      ? Center(child: Text("No courses found. Create one!"))
                      : GridView.builder(
                          itemCount: courses.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 400,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.9,
                              ),
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return FutureBuilder<List<int>>(
                                  future: Future.wait([
                                    _supabaseService.getEnrollmentCountForCourse(course['id'].toString()),
                                    _supabaseService.getExamCountForCourse(course['id'].toString()),
                                  ]),
                                  builder: (context, countSnapshot) {
                                    final studentCount = countSnapshot.data?[0] ?? 0;
                                    final examCount = countSnapshot.data?[1] ?? 0;
                                    return CoursesContainer(
                                          iconbackground: Colors.blue.shade100,
                                          iconcolor: Colors.blue,
                                          icon: FontAwesomeIcons.book,
                                          title: course['title'] ?? 'Course',
                                          subtitle: course['course_code'] ?? 'N/A',
                                          description:
                                              course['description'] ?? 'No description',
                                          students: studentCount,
                                          exams: examCount,
                                          average: "N/A",
                                          onManage: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ManageCoursePage(course: course),
                                              ),
                                            );
                                          },
                                        )
                                        .animate()
                                        .fadeIn(delay: (index * 200).ms)
                                        .slideY(
                                          begin: 0.1,
                                          end: 0,
                                          curve: Curves.easeOutQuad,
                                        );
                                  },
                                );
                          },
                        ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
