import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlertBox extends StatelessWidget {
  Function() onTap;
  AlertBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.r))),
      title: Text(
        'Delete Message?',
        style: TextStyle(color: Colors.deepPurple, fontSize: 20.sp),
      ),
      buttonPadding: EdgeInsets.symmetric(horizontal: 40.w),
      actionsPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      // content: Container(
      //   child: Text('fefewfwefwefwef'),
      // ),
      actions: [
        InkWell(
            onTap: onTap,
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 18.sp),
            )),
        InkWell(
            onTap: () {
              // Navigator.pop(context);
              Get.back();
            },
            child: Text(
              'No',
              style: TextStyle(fontSize: 18.sp),
            ))
      ],
    );
  }
}
