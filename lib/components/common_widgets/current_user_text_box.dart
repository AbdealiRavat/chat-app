import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utlis/colors.dart';

class CurrentUserTextBox extends StatelessWidget {
  final String sectionName;
  final String text;
  final Function()? onPressed;
  TextEditingController controller;
  bool isEdit;
  final IconData icon;
  CurrentUserTextBox(
      {super.key,
      required this.sectionName,
      required this.text,
      required this.onPressed,
      required this.controller,
      required this.isEdit,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.r), boxShadow: [
        BoxShadow(color: purple_secondary.withOpacity(0.05), blurRadius: 3, offset: const Offset(0.8, 1.5), spreadRadius: 0.3)
      ]),
      margin: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      padding: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w, bottom: 15.h),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      sectionName.toString(),
                      style:
                          TextStyle(fontSize: 15.sp, color: txt_grey, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
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
                SizedBox(
                  height: 30.h,
                  child: TextField(
                      enabled: isEdit,
                      controller: controller,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: purple_secondary),
                      decoration: InputDecoration(
                        border: isEdit
                            ? const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
                            : InputBorder.none,
                        focusedBorder: isEdit
                            ? const UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
                            : InputBorder.none,
                      )
                      // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
