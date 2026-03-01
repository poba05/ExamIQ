import 'package:examai/views/Landing/hero_section.dart';
import 'package:examai/views/Landing/navbar.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Navbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeroSection(),
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
