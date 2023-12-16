// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utlis/colors.dart';

class MyTextField extends StatefulWidget {
  TextEditingController? controller;
  // final FocusNode? focusNode;
  // final Function? focusChange;
  final String hintText;
  final dynamic tColor;
  final bool obscureText;
  final bool isPassword;
  bool isHidden;
  MyTextField(
      {super.key,
      this.controller,
      // this.focusNode,
      // this.focusChange,
      required this.hintText,
      required this.tColor,
      required this.obscureText,
      required this.isPassword,
      required this.isHidden});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      // padding: EdgeInsets.symmetric(horizontal: 20.w),
      // height: 55.h,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? widget.isHidden : false,
        // focusNode: widget.focusNode,
        // onEditingComplete: () {
        //   widget.focusChange!();
        // },
        style: TextStyle(color: widget.tColor),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            hintText: widget.hintText,
            suffix: InkWell(
                onTap: () {
                  setState(() {
                    widget.isHidden = !widget.isHidden;
                  });
                },
                child: Icon(widget.isHidden ? Icons.visibility : Icons.visibility_off_rounded,
                    color: widget.isPassword ? Colors.white : Colors.transparent)),
            // IconButton(
            //   padding: EdgeInsets.zero,
            //   onPressed: () {
            //     setState(() {
            //       widget.isHidden = !widget.isHidden;
            //     });
            //   },
            //   icon: widget.isHidden ? Icon(Icons.visibility) : Icon(Icons.visibility_off_rounded),
            //   color: widget.isPassword ? Colors.white : Colors.transparent,
            // ),
            filled: true,
            fillColor: purple_secondary.withOpacity(0.95),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(25.r)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: white.withOpacity(0.8), width: 0.5), borderRadius: BorderRadius.circular(25.r)),
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
