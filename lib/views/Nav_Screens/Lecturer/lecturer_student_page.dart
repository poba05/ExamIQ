import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:examai/utils/supabase_service.dart';

class LecturerStudentPage extends StatefulWidget {
  const LecturerStudentPage({super.key});

  @override
  State<LecturerStudentPage> createState() => _LecturerStudentPageState();
}

class _LecturerStudentPageState extends State<LecturerStudentPage> {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _supabaseService.getEnrolledStudentsForLecturer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final students = snapshot.data ?? [];
        final totalStudents = students.length;

        final sumlist = [
          {
            "id": 1,
            "icon": FontAwesomeIcons.users,
            "maintext": "$totalStudents",
            "subtext": "Total Students",
            "iconbg": Colors.blue.shade100,
            "iconcolor": Colors.blue,
          },
          {
            "id": 2,
            "icon": FontAwesomeIcons.userCheck,
            "maintext": "$totalStudents", // Simplified
            "subtext": "Active Students",
            "iconbg": Colors.green.shade100,
            "iconcolor": Colors.green,
          },
          {
            "id": 3,
            "icon": FontAwesomeIcons.solidStar,
            "maintext": "3.6", // Placeholder
            "subtext": "Average GPA",
            "iconbg": Colors.purple.shade100,
            "iconcolor": Colors.purple,
          },
          {
            "id": 4,
            "icon": FontAwesomeIcons.solidClock,
            "maintext": "0",
            "subtext": "Pending Enrollment",
            "iconbg": Colors.orange.shade100,
            "iconcolor": Colors.orange,
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopContainerLt(
              title: "Students",
              subtitle: "Manage your students",
              onPressed: () {},
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// STATS CARDS
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sumlist.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.4,
                        ),
                    itemBuilder: (context, index) {
                      final item = sumlist[index];
                      return Container(
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    item["maintext"]?.toString() ?? "0",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: AppColor.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    item["subtext"]?.toString() ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (index * 100).ms)
                          .scale(curve: Curves.easeOutQuad);
                    },
                  ),
                  const SizedBox(height: 32),

                  /// TABLE SECTION
                  Container(
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "All Students",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColor.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 240,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Search students...",
                                        prefixIcon: Icon(
                                          FontAwesomeIcons.magnifyingGlass,
                                          size: 14,
                                          color: AppColor.greyText,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: [
                                  DataColumn(label: _HeaderText('STUDENT')),
                                  DataColumn(label: _HeaderText('EMAIL')),
                                  DataColumn(label: _HeaderText('ROLE')),
                                  DataColumn(label: _HeaderText('ACTIONS')),
                                ],
                                rows: students.map((student) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor:
                                                  Colors.blue.shade50,
                                              child: Icon(
                                                FontAwesomeIcons.user,
                                                size: 14,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              student['full_name']
                                                      ?.toString() ??
                                                  'N/A',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          student['email']?.toString() ?? 'N/A',
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            'Student',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.solidEye,
                                                size: 14,
                                                color: AppColor.primaryBlue,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.envelope,
                                                size: 14,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.1, curve: Curves.easeOutQuad),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onViewStudent(Map<String, dynamic> student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing student: ${student["name"]}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onOpenAnalytics(Map<String, dynamic> student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analytics for: ${student["name"]}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onSendMessage(Map<String, dynamic> student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Send message to: ${student["email"]}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _courseChip(dynamic code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code?.toString() ?? "",
        style: TextStyle(
          fontSize: 11,
          color: AppColor.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }
}
