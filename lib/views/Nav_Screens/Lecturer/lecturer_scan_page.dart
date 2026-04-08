import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/containers/scanner_container.dart';
import 'package:examai/widgets/containers/top_container_lt.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LecturerScanPage extends StatefulWidget {
  const LecturerScanPage({super.key});

  @override
  State<LecturerScanPage> createState() => _LecturerScanPageState();
}

class _LecturerScanPageState extends State<LecturerScanPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopContainerLt(
          title: "Scan Papers",
          subtitle: "Welcome back, Dr. Smith",
          onPressed: () {},
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Handwritten Answer Sheets",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Our OCR technology will scan and digitize handwritten answers, then AI will grade them automatically.",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.greyText,
                        ),
                      ),
                      SizedBox(height: 20),
                      ScannerContainer(),
                    ],
                  ),
                ),
              ).animate().fadeIn().flipH(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                FontAwesomeIcons.solidEye,
                                color: AppColor.primaryBlue,
                                size: 24,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "OCR Processing",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Advanced optical character recognition converts handwriting to digital text with 95%+ accuracy.",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.greyText,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 100.ms).flipH(),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                FontAwesomeIcons.robot,
                                color: AppColor.primaryPurple,
                                size: 24,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "AI Grading",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "AI evaluates answers against marking schemes and provides detailed feedback and scores.",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.greyText,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).flipH(),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                FontAwesomeIcons.userCheck,
                                color: Colors.green,
                                size: 24,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Lecturer Approval",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Review, correct, and approve AI grades before publishing results to students.",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.greyText,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 200.ms).flipH(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
