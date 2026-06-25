import 'package:examai/constants/app_color.dart';
import 'package:examai/utils/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LiveMonitoringPage extends StatefulWidget {
  final Map<String, dynamic> exam;

  const LiveMonitoringPage({super.key, required this.exam});

  @override
  State<LiveMonitoringPage> createState() => _LiveMonitoringPageState();
}

class _LiveMonitoringPageState extends State<LiveMonitoringPage> {
  final SupabaseService _supabaseService = SupabaseService();
  late Stream<List<Map<String, dynamic>>> _examineesStream;

  @override
  void initState() {
    super.initState();
    // For a real app, we would use Supabase Realtime.
    // For now, we'll use a FutureBuilder that we refresh or a simple Stream.
    _examineesStream = Stream.periodic(const Duration(seconds: 5))
        .asyncMap((_) => _supabaseService.getActiveExaminees(widget.exam['id']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Live Exam Monitoring", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.exam['title'] ?? 'Exam', style: TextStyle(fontSize: 12, color: AppColor.greyText)),
          ],
        ),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: const Center(
              child: Row(
                children: [
                  Icon(Icons.wifi, color: Colors.green, size: 12),
                  SizedBox(width: 6),
                  Text(
                    "LIVE",
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _examineesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final examinees = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${examinees.length} Students Currently Testing",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.refresh, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text("Auto-refreshing every 5s", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: examinees.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: examinees.length,
                          itemBuilder: (context, index) {
                            final student = examinees[index];
                            final profile = student['profiles'] ?? {};
                            return _buildStudentCard(student, profile, index);
                          },

                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.userSlash, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("No students currently taking this exam", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student, Map<String, dynamic> profile, int index) {
    final snapshotUrl = _supabaseService.getExamSnapshotUrl(widget.exam['id'], profile['id']);

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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue.shade50,
                      child: Text(
                        (profile['full_name'] ?? 'S')[0],
                        style: TextStyle(color: AppColor.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile['full_name'] ?? 'Unknown Student',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Snapshot Image
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      snapshotUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(

                        child: Icon(Icons.videocam_off, color: Colors.grey),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildIndicator(Icons.camera_alt, Colors.green),
                    const SizedBox(width: 8),
                    _buildIndicator(Icons.mic, Colors.green),
                    const Spacer(),
                    const Text("LIVE", style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              height: 6,
              width: 6,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
  }


  Widget _buildIndicator(IconData icon, Color color) {
    return Icon(icon, size: 14, color: color);
  }
}
