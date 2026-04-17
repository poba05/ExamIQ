import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/containers/scan_assurance_cont.dart';
import 'package:examai/widgets/containers/scanner_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Scannercontainer extends StatelessWidget {
  const Scannercontainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey.shade300),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Scan Handwritten Exams",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Upload and process handwritten exam papers with OCR",
                    style: TextStyle(fontSize: 14, color: AppColor.greyText),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ScannerContainer(),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ScanAssuranceCont(
                        mainText: "OCR Processing",
                        subText: "converts handwriting to text",
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ScanAssuranceCont(
                        mainText: "Ai Grading",
                        subText: "Automatic answer validation",
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ScanAssuranceCont(
                        mainText: "Manual review",
                        subText: "Final Approval by lecturer",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.2);
  }
}
