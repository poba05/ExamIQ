import 'package:examai/constants/app_color.dart';
import 'package:examai/data/courses_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Availablecourses extends StatelessWidget {
  const Availablecourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // "Available Courses" section.
      margin: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header for the "Available Courses" section.
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
                  // Section title.
                  Text(
                    "Available Courses",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  Spacer(),
                  // "View all" button to see more courses.
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
          // Row to display course cards.
          Row(
            // Dynamically generate course cards from the `courses` data.
            children: courses.asMap().entries.map((entry) {
              final index = entry.key;
              final items = entry.value;
              return Expanded(
                    child: Container(
                      // Styling for each course card.
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
                        // Clip the content to the rounded border.
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Course image.
                            Image.asset(
                              items["image"] as String,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 5),
                            // Padding for the text content below the image.
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Course title.
                                  Text(
                                    items["title"] as String,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  // Course details.
                                  Text(
                                    items["details"] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.greyText,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    // Course code and "Apply" button.
                                    children: [
                                      Text(
                                        items["course"] as String,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.greyText,
                                        ),
                                      ),
                                      Spacer(),
                                      // Button to apply for the course.
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
                  // Animate each course card with a fade-in and slide-up effect.
                  .animate()
                  .fadeIn(delay: (800 + (index * 100)).ms, duration: 500.ms)
                  .slideY(begin: 0.5);
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(begin: 0.1);
  }
}
