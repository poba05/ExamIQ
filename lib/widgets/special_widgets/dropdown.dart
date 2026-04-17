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
      value: selectedCourse,
      isExpanded: true,
      iconSize: 20,
      hint: const Text("Select an option"),

      items: widget.mylist.map((course) {
        return DropdownMenuItem(
          value: course,
          child: Text(course, overflow: TextOverflow.ellipsis),
        );
      }).toList(),

      onChanged: (value) {
        setState(() {
          selectedCourse = value;
        });
      },

      decoration: InputDecoration(
        filled: false,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.primaryBlue, width: 2),
        ),
      ),
    );
  }
}
