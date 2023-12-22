import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/common_widgets/chat_user_text_box.dart';
import '../models/user_model.dart';
import '../utlis/colors.dart';

class ChatUserProfileScreen extends StatefulWidget {
  final UserModel userData;
  const ChatUserProfileScreen({super.key, required this.userData});

  @override
  State<ChatUserProfileScreen> createState() => _ChatUserProfileScreenState();
}

class _ChatUserProfileScreenState extends State<ChatUserProfileScreen> {
  final currentUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var timeStamp = widget.userData.timeStamp.toString();
    var formatTimeStamp = DateFormat('MMMM dd, yyyy').format(DateTime.parse(timeStamp));
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 15.h, top: 50.h),
          margin: EdgeInsets.only(bottom: 25.h),
          decoration: BoxDecoration(
              image: const DecorationImage(
                  // invertColors: true,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'asset/bgg.png',
                  )),
              color: bg_purple,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r))),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      height: 30.w,
                      // color: Colors.red,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: white,
                        size: 22.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              Center(
                child: SizedBox(width: 120.h, height: 120.h, child: buildProfileImage()),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                widget.userData.userName.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.sp, color: white, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                formatTimeStamp,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp, color: white, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatUserTextBox(
              sectionName: 'Name',
              text: widget.userData.userName.toString(),
              icon: Icons.person,
            ),
            ChatUserTextBox(
              sectionName: 'Email',
              text: widget.userData.email.toString(),
              icon: Icons.mail,
            ),
            ChatUserTextBox(
              sectionName: 'About',
              text: widget.userData.bio.toString(),
              icon: Icons.info_outline,
            ),
            SizedBox(
              height: 130.h,
            ),
          ],
        ),
      ],
    ));
  }

  Widget buildProfileImage() {
    String profileImgUrl = widget.userData.profileImg.toString();
    if (profileImgUrl.isNotEmpty) {
      // print("Profile Image URL: $profileImgUrl");

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

      return Container(
        height: 70.h,
        width: 70.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: white.withOpacity(0.9), shape: BoxShape.circle),
        child: Text(
          widget.userData.userName.toString().substring(0, 1),
          style: TextStyle(fontSize: 75.sp, color: bg_purple),
        ),
      );
    }
  }
}
