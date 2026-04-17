import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentReviewPopup extends StatelessWidget {
  StudentReviewPopup({super.key});

  final List<Map<String, dynamic>> reviewedQuestions = [
    {
      "question": "Explain the time complexity of quicksort in the worst case.",
      "student_answer":
          "In the worst case, quicksort takes O(n^2) time because the pivot is always the smallest or largest element, meaning the array is split into sizes n-1 and 0 recursively.",
      "suggested_answer":
          "Worst-case time complexity is O(n^2), occurring when the pivot chosen is consistently the greatest or smallest element, leading to unbalanced partitions.",
      "score": 10,
      "max_score": 10,
      "is_correct": true,
    },
    {
      "question": "Describe how a Queue data structure works.",
      "student_answer":
          "A queue works using LIFO (Last-In-First-Out) principle where the last element added is the first one removed.",
      "suggested_answer":
          "A queue operates on a FIFO (First-In-First-Out) principle, where elements are added at the rear and removed from the front.",
      "score": 2,
      "max_score": 10,
      "is_correct": false,
    },
    {
      "question": "Why is Merge Sort considered a stable sorting algorithm?",
      "student_answer":
          "Because it preserves the relative order of equal elements when merging the separated arrays.",
      "suggested_answer":
          "Merge sort is stable because during the merge phase, it always chooses the element from the left array when elements are equal, preserving their original order.",
      "score": 8,
      "max_score": 10,
      "is_correct": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 600,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Exam Review",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                        ),
                      ),
                      Text(
                        "CS201 - Data Structures",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.greyText,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Score: 85/100",
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: reviewedQuestions.length,
              itemBuilder: (context, index) {
                final item = reviewedQuestions[index];
                bool isCorrect = item["is_correct"];

                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q\${index + 1}.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item["question"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                          Icon(
                            isCorrect
                                ? FontAwesomeIcons.solidCircleCheck
                                : FontAwesomeIcons.solidCircleXmark,
                            color: isCorrect ? Colors.green : Colors.red,
                            size: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 15),
                      Text(
                        "Your Answer:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.greyText,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isCorrect
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                          ),
                        ),
                        child: Text(
                          item["student_answer"],
                          style: TextStyle(color: AppColor.black, height: 1.5),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Suggested Answer / Rubric:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.greyText,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          item["suggested_answer"],
                          style: TextStyle(color: AppColor.black, height: 1.5),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "Score: \${item['score']}/\${item['max_score']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCorrect
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
