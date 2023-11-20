// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utlis/constants.dart';

class PostTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  Function()? onPressed;
  PostTextField({super.key, required this.controller, required this.hintText, required this.focusNode, required this.onPressed});

  @override
  State<PostTextField> createState() => _PostTextFieldState();
}

class _PostTextFieldState extends State<PostTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      // height: 60.h,
      // width: 330.w,
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
              style: TextStyle(color: Colors.black, overflow: TextOverflow.fade),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 20.w,
                    top: 10.h,
                    bottom: 10.h,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.hintText,
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 20.w),
                    child: InkWell(
                        onTap: showBottomSheet,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 25.h,
                          color: Colors.black,
                        )),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepPurple),
                  child: Icon(
                    Icons.send,
                    size: 25.h,
                    color: Colors.white,
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
          await getImage(type);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
          decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              border: Border.all(width: 1, color: Colors.deepPurple),
              borderRadius: BorderRadius.circular(25.r)),
          child: Image.asset(
            imgPath,
            color: Colors.deepPurple,
            height: 35.h,
          ),
        ),
      ),
    );
  }

  getImage(type) async {
    var image = await ImagePicker().pickImage(source: type == 'Camera' ? ImageSource.camera : ImageSource.gallery);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    if (image == null) return;
    Navigator.pop(context);
    Reference imageRef = FirebaseStorage.instance
        .ref()
        .child('postImages')
        .child(FirebaseAuth.instance.currentUser!.uid.toString())
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    await imageRef.putFile(
        File(image.path),
        SettableMetadata(
          contentType: "image/jpeg",
        ));
    try {
      String imgUrl = await imageRef.getDownloadURL();
      FirebaseFirestore.instance
          .collection(Constants.userChats)
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .collection(FirebaseAuth.instance.currentUser!.uid.toString())
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'UserEmail': FirebaseAuth.instance.currentUser!.email,
        'UserName': userName,
        'Message': '',
        'imgMessage': imgUrl,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
