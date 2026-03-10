import 'package:examai/constants/app_color.dart';
import 'package:examai/models/sidebar_model.dart';
import 'package:examai/views/Landing/landing_page.dart';
// import 'package:examai/views/Dashboard/student_dashboard/student_dashboard.dart';
import 'package:examai/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late List<SidebarModel> items;

  @override
  void initState() {
    super.initState();
    items = [
      SidebarModel(
        icon: FontAwesomeIcons.house,
        title: "Dashboard",
        // page: StudentDashboard(),
      ),
      SidebarModel(
        icon: FontAwesomeIcons.bookOpen,
        title: "My Courses",
        // page: StudentDashboard(),
      ),
      SidebarModel(
        icon: FontAwesomeIcons.list,
        title: "Exams",
        // page: StudentDashboard(),
      ),
      SidebarModel(
        icon: FontAwesomeIcons.calendar,
        title: "Timetable",
        // page: StudentDashboard(),
      ),
      SidebarModel(
        icon: FontAwesomeIcons.chartLine,
        title: "Results",
        // page: StudentDashboard(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [AppColor.primaryBlue, AppColor.primaryPurple],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Icon(
                    FontAwesomeIcons.graduationCap,
                    color: AppColor.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 10),
                GradientText(text: "ExamIQ", fontSize: 20, height: 1.0),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(color: Colors.grey.shade300, thickness: 1),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(items.length, (index) {
                final item = items[index];

                final isSelected = index == widget.selectedIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    selectedTileColor: AppColor.primaryBlue,
                    leading: Icon(
                      item.icon,
                      color: isSelected
                          ? AppColor.primaryBlue
                          : AppColor.greyText,
                      size: 20,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColor.primaryBlue
                            : AppColor.greyText,
                      ),
                    ),
                    selected: isSelected,
                    onTap: () {
                      widget.onItemSelected(index);
                    },
                  ),
                );
              }),
            ),
          ),
          Spacer(),
          Divider(color: Colors.grey.shade300, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("lib/assets/lecturer_pic.jpg"),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Text(
                      "Student",
                      style: TextStyle(fontSize: 14, color: AppColor.greyText),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const LandingPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              final tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                        transitionDuration: const Duration(milliseconds: 400),
                      ),
                    );
                  },
                  child: Icon(
                    FontAwesomeIcons.arrowRightToBracket,
                    color: AppColor.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
