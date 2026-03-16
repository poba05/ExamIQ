import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String> mylist;
  const Dropdown({super.key, required this.mylist});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? selectedCourse;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedCourse,
      hint: Text("Select Course"),

      items: widget.mylist.map((course) {
        return DropdownMenuItem(value: course, child: Text(course));
      }).toList(),

      onChanged: (value) {
        setState(() {
          selectedCourse = value;
        });
      },

      decoration: InputDecoration(
        filled: false,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primaryBlue, width: 2),
        ),
      ),
    );
  }
}
