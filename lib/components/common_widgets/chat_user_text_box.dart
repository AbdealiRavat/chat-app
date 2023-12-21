import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utlis/colors.dart';

class ChatUserTextBox extends StatelessWidget {
  final String sectionName;
  final String text;
  final IconData icon;
  const ChatUserTextBox({
    super.key,
    required this.sectionName,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.r), boxShadow: [
        BoxShadow(color: purple_secondary.withOpacity(0.05), blurRadius: 5, offset: const Offset(2, 3), spreadRadius: 0.3)
      ]),
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 10.w,
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 25.w,
            color: deep_purple,
          ),
          SizedBox(
            width: 15.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionName.toString(),
                style: TextStyle(fontSize: 15.sp, color: txt_grey, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                text.toString(),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: purple_secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
