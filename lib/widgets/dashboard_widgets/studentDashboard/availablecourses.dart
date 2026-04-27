import 'package:examai/constants/app_color.dart';
import 'package:examai/data/courses_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:examai/utils/supabase_service.dart';

class Availablecourses extends StatelessWidget {
  const Availablecourses({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseService _db = SupabaseService();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _db.getAvailableCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SizedBox(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(height: 8),
                  Text("Error loading courses", style: TextStyle(color: Colors.red.shade700)),
                ],
              ),
            ),
          );
        }

        final courses = snapshot.data ?? [];

        return Container(
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
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 20, right: 20),
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
              courses.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(child: Text("No courses available at the moment.")),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: courses.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Container(
                            width: 300,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.blue.shade50,
                                    child: Icon(
                                      Icons.book,
                                      size: 50,
                                      color: AppColor.primaryBlue,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["title"] ?? 'Untitled Course',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          item["description"] ?? 'No description available',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.greyText,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              item["course_code"] ?? 'N/A',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.greyText,
                                              ),
                                            ),
                                            Spacer(),
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColor.primaryBlue,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 10,
                                                ),
                                              ),
                                              child: Text(
                                                "Enroll",
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
                          ).animate().fadeIn(delay: (200 + (index * 100)).ms, duration: 500.ms).slideX(begin: 0.1);
                        }).toList(),
                      ),
                    ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.1);
      },
    );
  }
}
