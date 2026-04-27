import 'package:examai/constants/app_color.dart';
import 'package:examai/data/lecturer_cousrses.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:examai/utils/supabase_service.dart';

class LecturerReviewPage extends StatefulWidget {
  const LecturerReviewPage({super.key});

  @override
  State<LecturerReviewPage> createState() => _LecturerReviewPageState();
}

class _LecturerReviewPageState extends State<LecturerReviewPage> {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _supabaseService.getPendingSubmissions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final pendingSubmissions = snapshot.data ?? [];
        final pendingCount = pendingSubmissions.length;

        final stats = [
          {
            "id": 1,
            "maintext": "$pendingCount",
            "Subtext": "Pending Reviews",
            "icon": FontAwesomeIcons.solidHourglassHalf,
            "iconColor": Colors.orange,
            "iconbg": Colors.orange.shade100,
            "bgcolor": AppColor.white,
          },
          {
            "id": 2,
            "maintext": "156", // Placeholder for approved
            "Subtext": "Approved Grades",
            "icon": FontAwesomeIcons.solidCircleCheck,
            "iconColor": Colors.green,
            "iconbg": Colors.green.shade100,
            "bgcolor": AppColor.white,
          },
          {
            "id": 3,
            "maintext": "96%",
            "Subtext": "AI Accuracy",
            "icon": FontAwesomeIcons.robot,
            "iconColor": Colors.blue,
            "iconbg": Colors.blue.shade100,
            "bgcolor": AppColor.white,
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopContainerLt(
              title: "Review Grades",
              subtitle: "Review and manage student grades",
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stats.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      childAspectRatio: 1.72,
                    ),
                    itemBuilder: (context, index) {
                      final item = stats[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: item["bgcolor"] as Color,
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
                                  color: item["iconColor"] as Color,
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
                                item["Subtext"] as String,
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Text(
                                "Submissions Awaiting Review",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.black,
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  "$pendingCount pending",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        pendingSubmissions.isEmpty 
                        ? Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Center(child: Text("All caught up! No pending reviews.", style: TextStyle(color: AppColor.greyText))),
                          )
                        : Column(
                          children: pendingSubmissions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final sub = entry.value;
                            final exam = sub['exams'] as Map? ?? {};
                            final student = sub['profiles'] as Map? ?? {};
                            
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          FontAwesomeIcons.userGraduate,
                                          color: AppColor.primaryBlue,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student['full_name']?.toString() ?? 'Unknown Student',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Exam: ${exam['title'] ?? 'N/A'}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColor.greyText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.primaryBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidEye,
                                            color: AppColor.white,
                                            size: 14,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Review",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(delay: (index * 200).ms).slideX(begin: 0.1, end: 0);
                          }).toList(),
                        ),
                      ],
                    ),
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
