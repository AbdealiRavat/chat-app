import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/user_model.dart';
import '../utlis/colors.dart';

class UserInfoScreen extends StatefulWidget {
  UserModel userData;
  UserInfoScreen({super.key, required this.userData});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildProfileImage(),
          Container(
              height: 120.h,
              width: 120.w,
              alignment: Alignment.center,
              color: white,
              child: Text(
                widget.userData.userName.toString(),
                style: TextStyle(fontSize: 25.sp, color: purple_text),
              )),
        ],
      ),
    );
  }

  Widget buildProfileImage() {
    String profileImgUrl = widget.userData.profileImg.toString();
    if (profileImgUrl.isNotEmpty) {
      print("Profile Image URL: $profileImgUrl");

      return CachedNetworkImage(
        imageUrl: profileImgUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: 120.h,
          width: 120.w,
          decoration: BoxDecoration(
            border: Border.all(width: 1.5.w, color: white, strokeAlign: BorderSide.strokeAlignOutside),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
            color: white,
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(
          color: purple_secondary,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      print("Profile Image URL: $profileImgUrl");

      return Container(
        height: 45.h,
        width: 45.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: white.withOpacity(0.9), shape: BoxShape.circle),
        child: Text(
          widget.userData.userName.toString().substring(0, 1),
          style: TextStyle(fontSize: 35.sp, color: bg_purple),
        ),
      );
    }
  }
}
