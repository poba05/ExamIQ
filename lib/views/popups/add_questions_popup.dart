import 'package:examai/constants/app_color.dart';
import 'package:examai/widgets/buttons/gradient_button_lg.dart';
import 'package:examai/widgets/textfields/Custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddQuestionsPopup extends StatefulWidget {
  const AddQuestionsPopup({super.key});

  @override
  State<AddQuestionsPopup> createState() => _AddQuestionsPopupState();
}

class _AddQuestionsPopupState extends State<AddQuestionsPopup> {
  int questionNumber = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 700,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      "Add Questions",
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
                    "Question \$questionNumber",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextfield(
                    label: "Enter question text",
                    obscure: false,
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Suggested Answer / Rubric",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextfield(
                    label: "Enter the expected answer or grading rubric",
                    obscure: false,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
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
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
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
                        "Done",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    Spacer(),
                    GradientButtonLg(
                      horizontalPadding: 40,
                      verticalPadding: 20,
                      onPressed: () {
                        setState(() {
                          questionNumber++;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.plus,
                            size: 20,
                            color: AppColor.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Save & Add Another",
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
