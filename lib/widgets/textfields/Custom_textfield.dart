import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool obscure;
  final int maxLines;
  const CustomTextfield({
    super.key,
    required this.label,
    this.icon,
    required this.obscure,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,

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
