import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utlis/colors.dart';

class MyTextBox extends StatelessWidget {
  final String sectionName;
  final String text;
  final Function()? onPressed;
  TextEditingController controller;
  bool isEdit;
  MyTextBox(
      {super.key,
      required this.sectionName,
      required this.text,
      required this.onPressed,
      required this.controller,
      required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      padding:
          EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w, bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                sectionName.toString(),
                style: TextStyle(
                    fontSize: 15.sp,
                    color: txt_grey,
                    fontWeight: FontWeight.w300),
              ),
              InkWell(
                onTap: onPressed,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    isEdit ? Icons.check_outlined : Icons.edit,
                    size: isEdit ? 25.w : 20.w,
                    color: Colors.deepPurple,
                  ),
                ),
              )
            ],
          ),
          // Text(
          //   text.toString(),
          //   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          // ),
          SizedBox(
            height: 35.h,
            child: TextField(
                enabled: isEdit,
                controller: controller,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: purple_secondary),
                decoration: InputDecoration(
                  border: isEdit
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple))
                      : InputBorder.none,
                  focusedBorder: isEdit
                      ? const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple))
                      : InputBorder.none,
                )
                // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))),
                ),
          ),
        ],
      ),
    );
  }
}
