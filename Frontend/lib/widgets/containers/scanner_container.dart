import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:examai/constants/app_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScannerContainer extends StatefulWidget {
  const ScannerContainer({super.key});

  @override
  State<ScannerContainer> createState() => _ScannerContainerState();
}

class _ScannerContainerState extends State<ScannerContainer> {
  bool ishovering = false;
  final List<PlatformFile> _pickedFiles = [];
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        ishovering = true;
      }),
      onExit: (_) => setState(() {
        ishovering = false;
      }),
      cursor: SystemMouseCursors.click,
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: ishovering ? AppColor.primaryBlue : AppColor.greyText,
          dashPattern: [6, 4],
          strokeWidth: 2,
        ),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 300),
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
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image, allowMultiple: true);
                    if (result != null) {
                      setState(() {
                        _pickedFiles.addAll(result.files);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                if (_pickedFiles.isNotEmpty)
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: List.generate(_pickedFiles.length, (index) {
                      final file = _pickedFiles[index];
                      return SizedBox(
                        width: 150,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    File(file.path!),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _pickedFiles.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              file.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.greyText,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                else
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
