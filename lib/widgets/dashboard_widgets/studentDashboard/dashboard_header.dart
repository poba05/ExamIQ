import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Student Dashboard",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: Supabase.instance.client
                      .from('profiles')
                      .select()
                      .eq('id', user?.id ?? '')
                      .single(),
                  builder: (context, snapshot) {
                    final name = snapshot.data?['full_name'] ?? 'User';
                    return Text(
                      "Welcome back, $name!",
                      style: TextStyle(fontSize: 14, color: AppColor.greyText),
                    );
                  },
                ),
              ],
            ),
            Spacer(),
            Icon(FontAwesomeIcons.bell, color: AppColor.greyText, size: 20),
          ],
        ),
      ),
    );
  }
}
