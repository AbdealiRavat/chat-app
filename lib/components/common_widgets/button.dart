import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utlis/colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isLoading;
  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 180.w,
          height: 55.h,
          padding: EdgeInsets.symmetric(vertical: isLoading ? 10.h : 18.h),
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 60.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r), color: Colors.white),
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(
                    color: bg_purple,
                    strokeWidth: 3,
                  )
                : Text(
                    text,
                    style: TextStyle(fontSize: 15.sp),
                  ),
          )),
    );
  }
}
