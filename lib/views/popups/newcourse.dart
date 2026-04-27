import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/special_widgets/dropdown.dart';
import 'package:examai/widgets/textfields/Custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:examai/utils/supabase_service.dart';

class Newcourse extends StatefulWidget {
  const Newcourse({super.key});

  @override
  State<Newcourse> createState() => _NewcourseState();
}

class _NewcourseState extends State<Newcourse> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  String? _selectedSemester;
  PlatformFile? _selectedPdf;
  bool _isCreating = false;

  final SupabaseService _supabaseService = SupabaseService();

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedPdf = result.files.first;
      });
    }
  }

  Future<void> _handleCreateCourse() async {
    if (_nameController.text.isEmpty ||
        _codeController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedSemester == null ||
        _unitsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      String? pdfUrl;
      if (_selectedPdf != null && _selectedPdf!.bytes != null) {
        pdfUrl = await _supabaseService.uploadCoursePdf(
          _selectedPdf!.bytes!,
          _selectedPdf!.name,
        );
      }

      await _supabaseService.createCourse(
        title: _nameController.text,
        courseCode: _codeController.text,
        description: _descriptionController.text,
        semester: _selectedSemester!,
        units: int.tryParse(_unitsController.text) ?? 0,
        pdfUrl: pdfUrl,
      );

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Course created successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error creating course: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 700,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(10),
          color: AppColor.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      "CREATE NEW COURSE",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        FontAwesomeIcons.xmark,
                        size: 20,
                        color: AppColor.greyText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Course Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextfield(
                    label: "e.g., Data Structures",
                    obscure: false,
                    controller: _nameController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Course Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextfield(
                    label: "e.g., CS201",
                    obscure: false,
                    controller: _codeController,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextfield(
                    label: "Enter course description",
                    obscure: false,
                    maxLines: 5,
                    controller: _descriptionController,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Semester",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            Dropdown(
                              mylist: const ["First Semester", "Second Semester"],
                              onChanged: (value) {
                                setState(() {
                                  _selectedSemester = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Units",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                            ),
                            SizedBox(height: 10),
                            CustomTextfield(
                              label: "units",
                              obscure: false,
                              controller: _unitsController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Course Material (PDF)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickPdf,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 1, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedPdf == null ? FontAwesomeIcons.fileArrowUp : FontAwesomeIcons.solidFilePdf,
                            color: _selectedPdf == null ? AppColor.greyText : Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedPdf?.name ?? "Click to upload course outline or material",
                              style: TextStyle(color: AppColor.greyText),
                            ),
                          ),
                          if (_selectedPdf != null)
                            IconButton(
                              onPressed: () => setState(() => _selectedPdf = null),
                              icon: const Icon(Icons.close, size: 18),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GradientButtonLg(
                      horizontalPadding: 40,
                      verticalPadding: 20,
                      onPressed: _isCreating ? null : () => _handleCreateCourse(),
                      child: Row(
                        children: [
                          if (_isCreating)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          else
                            Icon(
                              FontAwesomeIcons.circlePlus,
                              size: 20,
                              color: AppColor.white,
                            ),
                          const SizedBox(width: 5),
                          Text(
                            _isCreating ? "Creating..." : "Create Course",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
