// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/wall_controller.dart';
import '../utlis/colors.dart';

class PostTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  Function()? onPressed;
  String? chatId;
  String? msgTo;
  PostTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.focusNode,
    required this.onPressed,
    required this.chatId,
    required this.msgTo,
  });

  @override
  State<PostTextField> createState() => _PostTextFieldState();
}

class _PostTextFieldState extends State<PostTextField> {
  WallController wallController = Get.put(WallController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              maxLines: 5,
              minLines: 1,
              cursorOpacityAnimates: true,
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: TextStyle(color: black, overflow: TextOverflow.fade),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20.w,
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  filled: true,
                  fillColor: white,
                  hintText: widget.hintText,
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 20.w),
                    child: InkWell(
                        onTap: showBottomSheet,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 25.h,
                          color: black,
                        )),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: deep_purple,
                      ),
                      borderRadius: BorderRadius.circular(30.r)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(25.r)),
                  hintStyle: TextStyle(color: Colors.grey[500])),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.0.w),
            child: InkWell(
              onTap: widget.onPressed,
              child: Container(
                  // height: 25.h,
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: deep_purple),
                  child: Icon(
                    Icons.send,
                    size: 25.h,
                    color: white,
                  )),
            ),
          )
        ],
      ),
    );
  }

  Future showBottomSheet() {
    return showModalBottomSheet(
        useSafeArea: true,
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                iconsButton('asset/camera.png', 'Camera'),
                SizedBox(
                  width: 10.w,
                ),
                iconsButton('asset/gallery.png', 'Gallery'),
                SizedBox(
                  width: 10.w,
                ),
                iconsButton('asset/gallery.png', 'Gallery'),
              ],
            ),
          );
        });
  }

  iconsButton(String imgPath, String type) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          await wallController.getImage(type, widget.msgTo!);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
          decoration: BoxDecoration(
              color: deep_purple.withOpacity(0.1),
              border: Border.all(width: 1, color: deep_purple),
              borderRadius: BorderRadius.circular(25.r)),
          child: Image.asset(
            imgPath,
            color: deep_purple,
            height: 35.h,
          ),
        ),
      ),
    );
  }
}
