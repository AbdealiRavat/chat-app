// ignore_for_file: prefer_const_constructors

import 'package:chat_app/components/cards/users_list_tile.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/current_user_profile_page.dart';
import 'package:chat_app/pages/users_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/wall_controller.dart';
import '../utlis/colors.dart';
import '../utlis/constants.dart';
import 'chat_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final currentUser = FirebaseAuth.instance;
  String? data;
  TextEditingController textController = TextEditingController();
  ScrollController listViewController = ScrollController();

  bool showTime = false;
  FocusNode focusNode = FocusNode();
  WallController wallController = Get.put(WallController());
  AuthController authController = Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    Constants.initializePref();
    Future.microtask(() async {
      authController.getUserData(Constants.initializePref());
      await authController.getToken();
      WidgetsBinding.instance.addObserver(this);
      authController.setStatus("Online");
      authController.setToken();
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      authController.setStatus("Online");
    } else {
      authController.setStatus(DateTime.now().toString());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 0.h),
              height: 100.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      // invertColors: true,
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'asset/bgg.png',
                      )),
                  color: bg_purple,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Get.to(() => const CurrentUserProfilePage());
                        // authController.signOut(context);
                      },
                      child: Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              color: white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Icon(
                            Icons.menu,
                            size: 25.w,
                            color: Colors.white,
                          ))),
                  Text(
                    'Let\'s Chat',
                    style: TextStyle(color: white, fontSize: 18.sp),
                  ),
                  Icon(
                    Icons.people,
                    color: Colors.transparent,
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(Constants.users)
                      .orderBy('status')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data?.docs;
                      List usersList = wallController.usersList;
                      usersList = data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
                      if (usersList.isNotEmpty) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: usersList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Get.to(() => ChatScreen(userData: usersList[index])),
                                child: UsersListTile(userData: usersList[index]),
                              );
                            });
                      } else {
                        return Center(
                          child: Text('No Connections Found'),
                        );
                      }
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ));
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: InkWell(
          onTap: () {
            Get.to(() => UsersListScreen());
          },
          borderRadius: BorderRadius.circular(60.r),
          child: Container(
            height: 60.h,
            width: 60.h,
            decoration: BoxDecoration(color: purple_secondary, shape: BoxShape.circle),
            child: Icon(
              Icons.add,
              color: white,
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildProfileImage() {
  //   return Obx(() => authController.profileImg.isEmpty && profileController.profileImg.isEmpty
  //       ? Container(
  //           alignment: Alignment.center,
  //           decoration: BoxDecoration(
  //             color: white,
  //             borderRadius: BorderRadius.circular(100.r),
  //           ),
  //           child: Text(
  //             authController.userName.isEmpty ? '' : authController.userName.toString().substring(0, 1),
  //             style: TextStyle(fontSize: 30.sp, color: purple_text),
  //           ))
  //       : CachedNetworkImage(
  //           imageUrl: profileController.profileImg.isEmpty
  //               ? authController.profileImg.toString()
  //               : profileController.profileImg.toString(),
  //           imageBuilder: (context, imageProvider) => Container(
  //             decoration: BoxDecoration(
  //               border: Border.all(
  //                 width: 1.5.w,
  //                 color: white,
  //                 strokeAlign: BorderSide.strokeAlignOutside,
  //               ),
  //               image: DecorationImage(
  //                 image: imageProvider,
  //                 fit: BoxFit.cover,
  //               ),
  //               borderRadius: BorderRadius.circular(100.r),
  //               color: white,
  //             ),
  //           ),
  //           placeholder: (context, url) => CircularProgressIndicator(
  //             color: purple_secondary,
  //           ),
  //           errorWidget: (context, url, error) => const Icon(Icons.error),
  //         ));
  //
  // }
}
