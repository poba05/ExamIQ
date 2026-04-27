import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageCoursePage extends StatefulWidget {
  final Map<String, dynamic> course;
  const ManageCoursePage({super.key, required this.course});

  @override
  State<ManageCoursePage> createState() => _ManageCoursePageState();
}

class _ManageCoursePageState extends State<ManageCoursePage> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isUploading = false;
  late Map<String, dynamic> _currentCourse;

  @override
  void initState() {
    super.initState();
    _currentCourse = widget.course;
  }

  Future<void> _pickAndUploadPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.first.bytes != null) {
      setState(() => _isUploading = true);
      try {
        final pdfUrl = await _supabaseService.uploadCoursePdf(
          result.files.first.bytes!,
          result.files.first.name,
        );

        if (pdfUrl != null) {
          await _supabaseService.updateCoursePdf(_currentCourse['id'].toString(), pdfUrl);
          setState(() {
            _currentCourse['pdf_url'] = pdfUrl;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("PDF uploaded successfully!")),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload failed: $e")),
          );
        }
      } finally {
        if (mounted) setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _viewPdf() async {
    final pdfUrl = _currentCourse['pdf_url'];
    if (pdfUrl != null) {
      final uri = Uri.parse(pdfUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open PDF")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopContainerLt(
              title: _currentCourse['title'] ?? 'Course Details',
              subtitle: "Manage resources, students, and settings for ${_currentCourse['course_code'] ?? 'this course'}",
              buttonLabel: "Back to Courses",
              buttonIcon: FontAwesomeIcons.arrowLeft,
              onPressed: (context) => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Details & Materials
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Course Overview", FontAwesomeIcons.circleInfo),
                        const SizedBox(height: 20),
                        _buildInfoCard(),
                        const SizedBox(height: 40),
                        _buildSectionHeader("Course Materials", FontAwesomeIcons.fileLines),
                        const SizedBox(height: 20),
                        _buildMaterialsCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  // Right Side: Quick Stats & Students
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Enrollment Summary", FontAwesomeIcons.users),
                        const SizedBox(height: 20),
                        _buildStatsCard(),
                        const SizedBox(height: 40),
                        _buildSectionHeader("Recent Activities", FontAwesomeIcons.clockRotateLeft),
                        const SizedBox(height: 20),
                        _buildActivitiesCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColor.primaryBlue),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Course Code", _currentCourse['course_code'] ?? 'N/A'),
          const Divider(height: 30),
          _buildInfoRow("Semester", _currentCourse['semester'] ?? 'N/A'),
          const Divider(height: 30),
          _buildInfoRow("Credit Units", "${_currentCourse['units'] ?? '0'} Units"),
          const Divider(height: 30),
          Text(
            "Description",
            style: TextStyle(fontSize: 14, color: AppColor.greyText, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _currentCourse['description'] ?? 'No description provided.',
            style: TextStyle(fontSize: 15, color: AppColor.black, height: 1.5),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0);
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColor.greyText, fontSize: 15)),
        Text(
          value,
          style: TextStyle(color: AppColor.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMaterialsCard() {
    final pdfUrl = _currentCourse['pdf_url'];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : pdfUrl != null
              ? Column(
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.solidFilePdf, color: Colors.red.shade400, size: 30),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Course Material / Outline",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "Available for students",
                                style: TextStyle(color: AppColor.greyText, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _viewPdf,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("View"),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: _pickAndUploadPdf,
                          icon: Icon(FontAwesomeIcons.penToSquare, size: 18, color: AppColor.greyText),
                          tooltip: "Update PDF",
                        ),
                      ],
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    children: [
                      Icon(FontAwesomeIcons.fileCircleExclamation, color: AppColor.greyText, size: 40),
                      const SizedBox(height: 15),
                      Text(
                        "No materials uploaded yet",
                        style: TextStyle(color: AppColor.greyText),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _pickAndUploadPdf,
                        child: const Text("Upload Now"),
                      ),
                    ],
                  ),
                ),
    ).animate().fadeIn().slideX(begin: -0.1, end: 0, delay: 200.ms);
  }

  Widget _buildStatsCard() {
    return FutureBuilder<List<int>>(
      future: Future.wait([
        _supabaseService.getEnrollmentCountForCourse(_currentCourse['id'].toString()),
        _supabaseService.getExamCountForCourse(_currentCourse['id'].toString()),
      ]),
      builder: (context, snapshot) {
        final studentCount = snapshot.data?[0] ?? 0;
        final examCount = snapshot.data?[1] ?? 0;
        return Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.primaryBlue, AppColor.primaryPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  snapshot.connectionState == ConnectionState.waiting
                      ? const SizedBox(
                          height: 24, width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : _buildSimpleStat("$studentCount", "Students"),
                  Container(width: 1, height: 40, color: Colors.white24),
                  snapshot.connectionState == ConnectionState.waiting
                      ? const SizedBox(
                          height: 24, width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : _buildSimpleStat("$examCount", "Exams"),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24),
              const SizedBox(height: 10),
              Text(
                "Overall Performance: N/A",
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
              ),
            ],
          ),
        ).animate().fadeIn().slideX(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildSimpleStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActivitiesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildActivityItem("Course created", "Just now"),
          _buildActivityItem("System check", "2 hours ago"),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: const Text("View All Logs"),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0, delay: 200.ms);
  }

  Widget _buildActivityItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: AppColor.primaryBlue, shape: BoxShape.circle),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 14)),
          ),
          Text(time, style: TextStyle(color: AppColor.greyText, fontSize: 12)),
        ],
      ),
    );
  }
}
