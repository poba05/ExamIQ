import 'package:dotted_border/dotted_border.dart';
import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScannerContainer extends StatefulWidget {
  const ScannerContainer({super.key});

  @override
  State<ScannerContainer> createState() => _ScannerContainerState();
}

class _ScannerContainerState extends State<ScannerContainer> {
  bool is_hovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        is_hovering = true;
      }),
      onExit: (_) => setState(() {
        is_hovering = false;
      }),
      cursor: SystemMouseCursors.click,
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: is_hovering ? AppColor.primaryBlue : AppColor.greyText,
          dashPattern: [6, 4],
          strokeWidth: 2,
        ),
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  radius: 40,
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.cloudArrowUp,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Upload Exam Questions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Drag and Drop files or click to browse",
                  style: TextStyle(fontSize: 14, color: AppColor.greyText),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.folderOpen,
                        size: 16,
                        color: AppColor.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Select Files",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Supports PDF, JPG, PNG • Max 50MB per file",
                  style: TextStyle(fontSize: 10, color: AppColor.greyText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
