import 'package:examai/constants/app_color.dart';
import 'package:examai/constants/footer/footercolumn.dart';
import 'package:examai/constants/footer/logo_section.dart';
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.navyblue,
      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 60),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 60,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              LogoSection(),
              Footercolumn(
                title: "Product",
                items: ["Features", "Pricing", "Security"],
              ),
              Footercolumn(
                title: "Company",
                items: ["About", "Blog", "Careers"],
              ),
              Footercolumn(
                title: "Support",
                items: ["Help Center", "Contact", "Privacy"],
              ),
            ],
          ),
          SizedBox(height: 40),
          Divider(color: AppColor.greyText, thickness: 1),
          Text(
            "© 2024 ExamAI. All rights reserved.",
            style: TextStyle(color: AppColor.greyText, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
