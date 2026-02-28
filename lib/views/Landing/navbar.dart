import 'package:examai/widgets/gradient_button.dart';
import 'package:examai/widgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Navbar extends StatelessWidget {
  static const tags = ["Features", "How it works", "Pricing"];
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 60, right: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    FontAwesomeIcons.graduationCap,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 10),
                GradientText(text: "ExamIQ"),
              ],
            ),
            SizedBox(
              child: Row(
                children: [
                  ...tags.map((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          tag,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    );
                  }),
                  SizedBox(width: 8),
                  GradientButton(text: "Get Started", onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
