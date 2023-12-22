import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/common_widgets/chat_user_text_box.dart';
import 'package:chat_app/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/common_widgets/current_user_text_box.dart';
import '../controllers/auth_controller.dart';
import '../utlis/colors.dart';
import '../utlis/constants.dart';

class CurrentUserProfilePage extends StatefulWidget {
  const CurrentUserProfilePage({super.key});

  @override
  State<CurrentUserProfilePage> createState() => _CurrentUserProfilePageState();
}

class _CurrentUserProfilePageState extends State<CurrentUserProfilePage> {
  final currentUser = FirebaseAuth.instance;

  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  AuthController authController = Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    Future.microtask(() async {
      await Constants.initializePref();
      profileController.getData(userNameController, bioController);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'Profile Page',
        //     style: TextStyle(color: Colors.white, fontSize: 20.sp),
        //   ),
        //   leading: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 30.w),
        //     child: GestureDetector(
        //       onTap: () => Get.back(),
        //       child: Icon(
        //         Icons.arrow_back_ios,
        //         color: white,
        //         size: 22.w,
        //       ),
        //     ),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: bg_purple,
        //   elevation: 0,
        // ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection(Constants.users).doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                var timeStamp = data?.data()?['timeStamp'];
                var formatTimeStamp = DateFormat('MMMM dd, yyyy').format(DateTime.parse(timeStamp));
                // print(data?.data()?['timeStamp']);
                return ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 15.h, top: 50.h),
                      margin: EdgeInsets.only(bottom: 25.h),
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                'asset/bgg.png',
                              )),
                          color: bg_purple,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Text(
                                'Profile Page',
                                style: TextStyle(color: Colors.white, fontSize: 20.sp),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.transparent,
                                  size: 22.w,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 55.h,
                          ),
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                SizedBox(width: 120.h, height: 120.h, child: buildProfileImage()),
                                InkWell(
                                  onTap: showBottomSheet,
                                  child: Container(
                                    padding: EdgeInsets.all(5.w),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.deepPurple),
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
                            height: 15.h,
                          ),
                          Text(
                            data?.data()?['userName'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.sp, color: white, fontWeight: FontWeight.w500),
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
                        ChatUserTextBox(sectionName: 'Email', text: data?.data()?['email'], icon: Icons.mail),
                        Obx(() => CurrentUserTextBox(
                              sectionName: 'Name',
                              text: authController.userName.toString(),
                              // text: userData['userName'] ?? '',
                              onPressed: () => profileController.editUserName('userName', userNameController),
                              controller: userNameController,
                              isEdit: profileController.isNameEdit.value, icon: Icons.person,
                            )),
                        Obx(() => CurrentUserTextBox(
                              sectionName: 'About',
                              text: profileController.bio.toString(),
                              // text: userData['bio'] ?? '',
                              onPressed: () => profileController.editBio('bio', bioController),
                              controller: bioController,
                              isEdit: profileController.isBioEdit.value, icon: Icons.info_outline,
                            )),
                        SizedBox(
                          height: 30.h,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => authController.signOut(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 10.w),
                        margin: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 110.w),
                        decoration:
                            BoxDecoration(color: purple_secondary.withOpacity(0.05), borderRadius: BorderRadius.circular(20.r)),
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
                              style: TextStyle(fontSize: 16.sp, color: Colors.red, fontWeight: FontWeight.w500, letterSpacing: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ));
              }
            }));
  }

  showBottomSheet() {
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
                SizedBox(
                  width: 10.w,
                ),
                iconsButton('asset/camera.png', 'Camera'),
                SizedBox(
                  width: 50.w,
                ),
                iconsButton('asset/gallery.png', 'Gallery'),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
          );
        });
  }

  iconsButton(String imgPath, String type) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          await profileController.getImage(type, context);
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

  Widget buildProfileImage() {
    String? profileImgUrl = Constants.prefs.getString(Constants.profileImg);

    if (profileImgUrl != null && Uri.parse(profileImgUrl).isAbsolute) {
      return Obx(() => CachedNetworkImage(
            imageUrl: profileController.profileImg.isEmpty ? profileImgUrl : profileController.profileImg.toString(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: profileController.isLoading.value
                  ? BoxDecoration(
                      border: Border.all(
                        width: 1.5.w,
                        color: white,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      borderRadius: BorderRadius.circular(100.r))
                  : BoxDecoration(
                      border: Border.all(
                        width: 1.5.w,
                        color: white,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(100.r),
                      color: white,
                    ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(
              color: purple_secondary,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ));
    } else {
      return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Text(
            Constants.prefs.getString(Constants.userName).substring(0, 1) ?? '',
            style: TextStyle(fontSize: 80.sp, color: purple_text),
          )); // Placeholder or default image
    }
  }
}
