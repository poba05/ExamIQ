import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';

class LecturerCustomBtn extends StatefulWidget {
  final Color iconbg;
  final Color iconcolor;
  final IconData icon;
  final String boldText;
  final String text;
  final Function onTap;
  LecturerCustomBtn({
    super.key,
    required this.iconbg,
    required this.iconcolor,
    required this.icon,
    required this.text,
    required this.boldText,
    required this.onTap,
  });

  @override
  State<LecturerCustomBtn> createState() => _LecturerCustomBtnState();
}

class _LecturerCustomBtnState extends State<LecturerCustomBtn> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onTap(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50, //
                width: 50, //
                decoration: BoxDecoration(
                  color: _isHovering ? widget.iconcolor : widget.iconbg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovering ? AppColor.white : widget.iconcolor,
                  size: 20,
                ),
              ),
              SizedBox(height: 15),
              Text(
                widget.boldText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.text,
                style:  TextStyle(fontSize: 14, color: AppColor.greyText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
