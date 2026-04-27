import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCoursesPage extends StatefulWidget {
  const StudentCoursesPage({super.key});

  @override
  State<StudentCoursesPage> createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            decoration: BoxDecoration(
              color: AppColor.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Courses',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Explore and manage your academic progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.greyText,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      FontAwesomeIcons.solidBell,
                      color: AppColor.greyText,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TabBar(
                  labelColor: AppColor.primaryBlue,
                  unselectedLabelColor: AppColor.greyText,
                  indicatorColor: AppColor.primaryBlue,
                  tabs: const [
                    Tab(text: "My Courses"),
                    Tab(text: "Available Courses"),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              children: [
                _buildCourseList(isEnrolled: true),
                _buildCourseList(isEnrolled: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList({required bool isEnrolled}) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: isEnrolled
          ? _supabaseService.getEnrolledCourses()
          : _supabaseService.getAvailableCourses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading courses:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final courses = snapshot.data ?? [];

        if (courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isEnrolled
                      ? FontAwesomeIcons.bookOpen
                      : FontAwesomeIcons.magnifyingGlass,
                  size: 40,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  isEnrolled
                      ? "You haven't enrolled in any courses yet."
                      : "No new courses available at the moment.",
                  style: TextStyle(color: AppColor.greyText),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEnrolled) ...[
                // Stats row only for My Courses
                Row(
                  children: [
                    _statChip(
                      '${courses.length}',
                      'Active',
                      Colors.blue,
                      FontAwesomeIcons.bookOpen,
                    ),
                    const SizedBox(width: 16),
                    _statChip(
                      '0',
                      'Completed',
                      Colors.grey,
                      FontAwesomeIcons.flagCheckered,
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                const SizedBox(height: 28),
              ],
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courses.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 420,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return _CourseCard(
                        course: course,
                        isEnrolledTab: isEnrolled,
                        onEnrolled: () => setState(() {}),
                      )
                      .animate()
                      .fadeIn(delay: (index * 100).ms, duration: 400.ms)
                      .slideY(begin: 0.1);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statChip(String value, String label, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 13, color: AppColor.greyText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  final bool isEnrolledTab;
  final VoidCallback onEnrolled;

  const _CourseCard({
    required this.course,
    required this.isEnrolledTab,
    required this.onEnrolled,
  });

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _hovered = false;
  bool _isEnrolling = false;
  final SupabaseService _supabaseService = SupabaseService();

  Future<void> _launchURL(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open the course material")),
        );
      }
    }
  }

  Future<void> _enroll() async {
    setState(() => _isEnrolling = true);
    try {
      await _supabaseService.enrollInCourse(widget.course['id'].toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enrolled in ${widget.course['title']}")),
        );
        widget.onEnrolled();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Enrollment failed: $e")));
      }
    } finally {
      if (mounted) setState(() => _isEnrolling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    
    // Robust lecturer name extraction
    String lecturerName = 'TBD';
    if (c['profiles'] != null) {
      if (c['profiles'] is List) {
        if ((c['profiles'] as List).isNotEmpty) {
          lecturerName = c['profiles'][0]['full_name'] ?? 'TBD';
        }
      } else if (c['profiles'] is Map) {
        lecturerName = c['profiles']['full_name'] ?? 'TBD';
      }
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hovered
            ? Matrix4.translationValues(0.0, -6.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? Colors.blue.withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _hovered ? 20 : 10,
              spreadRadius: _hovered ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.book,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  if (widget.isEnrolledTab)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Active",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                c['title'] ?? 'Unknown Course',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${c['course_code']} · $lecturerName',
                style: TextStyle(fontSize: 13, color: AppColor.greyText),
              ),
              const Spacer(),
              if (widget.isEnrolledTab) ...[
                if (c['pdf_url'] != null && (c['pdf_url'] as String).isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _launchURL(c['pdf_url'] as String),
                      icon: const Icon(FontAwesomeIcons.filePdf, size: 14),
                      label: const Text("Course Material"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.primaryBlue,
                        side: BorderSide(color: AppColor.primaryBlue),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Text(
                      'Progress',
                      style: TextStyle(fontSize: 12, color: AppColor.greyText),
                    ),
                    const Spacer(),
                    const Text(
                      '0%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.0,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isEnrolling ? null : _enroll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isEnrolling
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Enroll Now",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.calendar,
                    size: 12,
                    color: AppColor.greyText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.isEnrolledTab
                        ? 'Next: Upcoming Exam'
                        : '${c['units']} Units',
                    style: TextStyle(fontSize: 12, color: AppColor.greyText),
                  ),
                  const Spacer(),
                  if (widget.isEnrolledTab)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "N/A",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryBlue,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
