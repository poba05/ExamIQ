import 'package:examai/constants/app_color.dart';
import 'package:examai/data/student_data.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:examai/widgets/special_widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LecturerStudentPage extends StatefulWidget {
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
  const LecturerStudentPage({super.key});

  @override
  State<LecturerStudentPage> createState() => _LecturerStudentPageState();
}

class _LecturerStudentPageState extends State<LecturerStudentPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopContainerLt(
          title: "Students",
          subtitle: "Welcome back, Mr Smith",
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
                itemCount: LecturerStudentPage.sumlist.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final item = LecturerStudentPage.sumlist[index];
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
                                  color:
                                      item["iconbg"] as Color? ??
                                      Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  item["icon"] as IconData? ??
                                      FontAwesomeIcons.question,
                                  color:
                                      item["iconcolor"] as Color? ??
                                      Colors.grey,
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
                        /// TOP BAR
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 24,
                              runSpacing: 16,
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "All Students",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColor.black,
                                  ),
                                ),

                                /// CONTROLS GROUP (Search, Dropdown, Button)
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    /// SEARCH
                                    SizedBox(
                                      width: 210,
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

                                    /// DROPDOWN
                                    SizedBox(
                                      width: 150,
                                      child: Dropdown(
                                        mylist: const [
                                          "All Status",
                                          "Active",
                                          "Inactive",
                                          "Pending",
                                        ],
                                      ),
                                    ),

                                    /// ADD STUDENT BUTTON
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // TODO: Implement navigation to Add Student page
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Add Student feature coming soon',
                                            ),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.plus,
                                        size: 14,
                                      ),
                                      label: const Text("Add Student"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.primaryBlue,
                                        foregroundColor: AppColor.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        elevation: 0,
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Divider(height: 1),

                        /// TABLE
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 1000),
                            child: DataTable(
                              dataRowMinHeight: 60,
                              dataRowMaxHeight: 70,
                              columnSpacing: 40,
                              headingRowColor: WidgetStateProperty.all(
                                Colors.grey.shade200,
                              ),

                              /// HEADERS
                              columns: [
                                DataColumn(label: _HeaderText('STUDENT')),
                                DataColumn(label: _HeaderText('STUDENT ID')),
                                DataColumn(label: _HeaderText('COURSES')),
                                DataColumn(label: _HeaderText('GPA')),
                                DataColumn(label: _HeaderText('AVG SCORE')),
                                DataColumn(label: _HeaderText('STATUS')),
                                DataColumn(label: _HeaderText('LAST ACTIVE')),
                                DataColumn(label: _HeaderText('ACTIONS')),
                              ],

                              /// ROWS
                              rows: students.map((item) {
                                return DataRow(
                                  cells: [
                                    /// STUDENT
                                    DataCell(
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundImage:
                                                (item["pic"]?.toString() ?? "")
                                                    .isNotEmpty
                                                ? AssetImage(
                                                    item["pic"]?.toString() ??
                                                        "",
                                                  )
                                                : null,
                                            child:
                                                (item["pic"]?.toString() ?? "")
                                                    .isEmpty
                                                ? Icon(
                                                    FontAwesomeIcons.user,
                                                    size: 16,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item["name"]?.toString() ??
                                                      "N/A",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  item["email"]?.toString() ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// ID
                                    DataCell(
                                      Text(
                                        item["student_id"]?.toString() ?? "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.greyText,
                                        ),
                                      ),
                                    ),

                                    /// COURSES (FIXED)
                                    DataCell(
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          _courseChip(item["course1code"]),
                                          _courseChip(item["course2code"]),
                                          _courseChip(item["course3code"]),
                                        ],
                                      ),
                                    ),

                                    /// 🎓 GPA
                                    DataCell(
                                      Text(
                                        (item["gpa"] ?? 0.0).toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: () {
                                            final gpa =
                                                item["gpa"] as double? ?? 0.0;
                                            if (gpa >= 3.5) return Colors.green;
                                            if (gpa >= 2.5) {
                                              return Colors.orange;
                                            }
                                            return Colors.red;
                                          }(),
                                        ),
                                      ),
                                    ),

                                    /// AVG SCORE
                                    DataCell(
                                      SizedBox(
                                        width: 130,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Builder(
                                                builder: (context) {
                                                  final avgScore =
                                                      item["Avg_score"];
                                                  double percentage = 0;

                                                  if (avgScore is String) {
                                                    percentage =
                                                        double.tryParse(
                                                          avgScore.replaceAll(
                                                            '%',
                                                            '',
                                                          ),
                                                        ) ??
                                                        0;
                                                  } else if (avgScore is num) {
                                                    percentage = avgScore
                                                        .toDouble();
                                                  }

                                                  // Normalizes value: handles 85 (as in 85%) or 0.85
                                                  var value = percentage > 1
                                                      ? percentage / 100
                                                      : percentage;
                                                  // Clamp to valid range [0.0, 1.0]
                                                  value = value.clamp(0.0, 1.0);

                                                  return LinearProgressIndicator(
                                                    value: value,
                                                    backgroundColor:
                                                        Colors.grey.shade200,
                                                    color: value < 0.5
                                                        ? Colors.red
                                                        : value < 0.75
                                                        ? Colors.orange
                                                        : Colors.green,
                                                    minHeight: 8,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              item["Avg_score"]?.toString() ??
                                                  "0%",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    ///STATUS
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item["status"] == "Active"
                                              ? Colors.green.shade100
                                              : item["status"] == "Inactive"
                                              ? Colors.grey.shade200
                                              : Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          item["status"]?.toString() ??
                                              "Active",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: item["status"] == "Active"
                                                ? Colors.green
                                                : item["status"] == "Inactive"
                                                ? Colors.grey
                                                : Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// LAST ACTIVE
                                    DataCell(
                                      Text(
                                        item["last_active"]?.toString() ?? "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),

                                    /// ACTIONS (FIXED)
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.solidEye,
                                              size: 14,
                                              color: AppColor.primaryBlue,
                                            ),
                                            tooltip: 'View student',
                                            onPressed: () =>
                                                _onViewStudent(item),
                                            constraints: const BoxConstraints(
                                              minHeight: 24,
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          SizedBox(width: 12),
                                          IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.chartLine,
                                              size: 14,
                                              color: AppColor.greyText,
                                            ),
                                            tooltip: 'View analytics',
                                            onPressed: () =>
                                                _onOpenAnalytics(item),
                                            constraints: const BoxConstraints(
                                              minHeight: 24,
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          SizedBox(width: 12),
                                          IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.envelope,
                                              size: 14,
                                              color: Colors.green,
                                            ),
                                            tooltip: 'Send message',
                                            onPressed: () =>
                                                _onSendMessage(item),
                                            constraints: const BoxConstraints(
                                              minHeight: 24,
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
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
  }

  void _onViewStudent(Map<String, dynamic> student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing student: ${student["name"]}'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to student detail page
  }

  void _onOpenAnalytics(Map<String, dynamic> student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analytics for: ${student["name"]}'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Navigate to analytics page
  }

  void _onSendMessage(Map<String, dynamic> student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Send message to: ${student["email"]}'),
        duration: const Duration(seconds: 1),
      ),
    );
    // TODO: Open messaging/email interface
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
