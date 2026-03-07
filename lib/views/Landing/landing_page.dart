import 'package:examai/constants/app_color.dart';
import 'package:examai/constants/footer/footer.dart';
import 'package:examai/views/Landing/features.dart';
import 'package:examai/views/Landing/hero_section.dart';
import 'package:examai/constants/navbar.dart';
import 'package:examai/views/Landing/get_started.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          Navbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeroSection(),
                  Features(),
                  GetStarted(),
                  Footer(),
                  // Add more sections here
                  // FeaturesSection(),
                  // PricingSection(),
                  // etc.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
