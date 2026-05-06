import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SystemActivity extends StatelessWidget {
  const SystemActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {
        "type": "login",
        "user": "Dr. Smith",
        "action": "Logged in",
        "time": "2 minutes ago",
        "icon": FontAwesomeIcons.rightToBracket,
        "color": Colors.blue
      },
      {
        "type": "create",
        "user": "Admin",
        "action": "Created course 'CSC 301'",
        "time": "15 minutes ago",
        "icon": FontAwesomeIcons.plus,
        "color": Colors.green
      },
      {
        "type": "error",
        "user": "System",
        "action": "Failed database connection attempt",
        "time": "1 hour ago",
        "icon": FontAwesomeIcons.triangleExclamation,
        "color": Colors.red
      },
      {
        "type": "update",
        "user": "Prof. Johnson",
        "action": "Uploaded new exam material",
        "time": "3 hours ago",
        "icon": FontAwesomeIcons.fileArrowUp,
        "color": Colors.purple
      },
      {
        "type": "delete",
        "user": "Admin",
        "action": "Removed student account 'st_098'",
        "time": "5 hours ago",
        "icon": FontAwesomeIcons.trashCan,
        "color": Colors.orange
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "System Activity",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: ListView.separated(
                itemCount: activities.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final act = activities[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (act['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(act['icon'] as IconData, size: 16, color: act['color'] as Color),
                    ),
                    title: Text("${act['user']} - ${act['action']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(act['time'] as String),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                  ).animate().fadeIn(delay: (index * 100).ms);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
