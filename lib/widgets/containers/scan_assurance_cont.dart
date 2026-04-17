import 'package:examai/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScanAssuranceCont extends StatelessWidget {
  final String mainText;
  final String subText;
  const ScanAssuranceCont({
    super.key,
    required this.mainText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                mainText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              Spacer(),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.green,
                child: Icon(
                  FontAwesomeIcons.check,
                  size: 10,
                  color: AppColor.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            subText,
            style: TextStyle(fontSize: 12, color: AppColor.greyText),
          ),
        ],
      ),
    );
  }
}
