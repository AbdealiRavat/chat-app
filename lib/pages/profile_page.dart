import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../components/common_widgets/text_box.dart';
import '../components/loaders/loader.dart';
import '../controllers/auth_controller.dart';
import '../utlis/colors.dart';
import '../utlis/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance;

  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    Future.microtask(
        () => authController.getData(userNameController, bioController));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: bg_purple,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 15.h),
                    margin: EdgeInsets.only(bottom: 25.h),
                    decoration: BoxDecoration(
                        color: bg_purple,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(25.r))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              // Container(
                              //   height: 120.h,
                              //   width: 120.w,
                              //   decoration: Constants.profileImg.isNotEmpty
                              //       ? Constants.prefs.getString(Constants.profileImg).isEmpty || authController.profileImg.isEmpty
                              //           ? const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)
                              //           : BoxDecoration(
                              //               border:
                              //                   Border.all(width: 3.w, color: white, strokeAlign: BorderSide.strokeAlignOutside),
                              //               image: DecorationImage(
                              //                 image: NetworkImage(Constants.prefs.getString(Constants.profileImg)),
                              //                 fit: BoxFit.cover,
                              //               ),
                              //               shape: BoxShape.circle,
                              //               color: Colors.white)
                              //       : const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                              //   child:
                              //       Constants.prefs.getString(Constants.profileImg).isEmpty || authController.profileImg.isEmpty
                              //           ? Container(
                              //               height: 120.h,
                              //               width: 120.w,
                              //               alignment: Alignment.center,
                              //               child: Text(
                              //                 Constants.prefs.getString(Constants.userName).toString().substring(0, 1),
                              //                 style: TextStyle(fontSize: 80.sp, color: Colors.white),
                              //               ))
                              //           : const SizedBox(),
                              // ),
                              Constants.prefs
                                      .getString(Constants.profileImg)
                                      .toString()
                                      .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(60.r),
                                      child: Image.network(
                                        Constants.prefs
                                            .getString(Constants.profileImg),
                                        fit: BoxFit.cover,
                                        width: 120.w,
                                        height: 120.h,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            width: 120.w,
                                            height: 120.h,
                                            color: Colors.white,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.deepPurple,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, object, stackTrace) {
                                          return Container(
                                              height: 120.h,
                                              width: 120.w,
                                              alignment: Alignment.center,
                                              color: white,
                                              child: Text(
                                                Constants.prefs
                                                    .getString(
                                                        Constants.userName)
                                                    .toString()
                                                    .substring(0, 1),
                                                style: TextStyle(
                                                    fontSize: 80.sp,
                                                    color: purple_text),
                                              ));
                                        },
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(60.r),
                                      child: Container(
                                          height: 120.h,
                                          width: 120.w,
                                          alignment: Alignment.center,
                                          color: white,
                                          child: Text(
                                            Constants.prefs
                                                .getString(Constants.userName)
                                                .toString()
                                                .substring(0, 1),
                                            style: TextStyle(
                                                fontSize: 80.sp,
                                                color: purple_text),
                                          )),
                                    ),
                              InkWell(
                                onTap: showBottomSheet,
                                child: Container(
                                  padding: EdgeInsets.all(5.w),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.deepPurple),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 22.w,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.email ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(left: 25.w),
                      //   child: Text(
                      //     'My Details',
                      //     style: TextStyle(fontSize: 15.sp, color: purple_secondary),
                      //   ),
                      // ),
                      Obx(() => MyTextBox(
                          sectionName: 'UserName',
                          text: authController.userName.toString(),
                          // text: userData['userName'] ?? '',
                          onPressed: () => authController.editUserName(
                              'userName', userData, userNameController),
                          controller: userNameController,
                          isEdit: authController.isNameEdit.value)),
                      Obx(() => MyTextBox(
                          sectionName: 'Bio',
                          text: authController.bio.toString(),
                          // text: userData['bio'] ?? '',
                          onPressed: () => authController.editBio(
                              'bio', userData, bioController),
                          controller: bioController,
                          isEdit: authController.isBioEdit.value)),
                      SizedBox(
                        height: 150.h,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => authController.signOut(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 18.0.h, horizontal: 10.w),
                      margin: EdgeInsets.symmetric(
                          vertical: 5.0.h, horizontal: 110.w),
                      decoration: BoxDecoration(
                          color: purple_secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r)),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 25.w,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            return const Loader();
          }),
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
        useSafeArea: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
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
          await authController.getImage(type, context);
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
}
