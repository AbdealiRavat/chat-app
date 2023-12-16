import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/users_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
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

  @override
  void initState() {
    Constants.initializePref();
    Future.microtask(() async {
      authController.getUserData(Constants.initializePref());
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      String? token = await FirebaseMessaging.instance.getToken();
      WidgetsBinding.instance.addObserver(this);

      print(token.toString());
      authController.setStatus("Online");
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
              decoration: BoxDecoration(color: bg_purple, borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() => InkWell(
                      onTap: () {
                        Get.to(() => const ProfilePage());
                        // authController.signOut(context);
                      },
                      child: Container(
                        height: 45.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5.w, color: white, strokeAlign: BorderSide.strokeAlignOutside),
                          shape: BoxShape.circle,
                          color: authController.profileImg.isEmpty ? white.withOpacity(0.9) : white.withOpacity(0.5),
                          image: authController.profileImg.isEmpty
                              ? Constants.prefs != null &&
                                      Constants.prefs.getString(Constants.profileImg) != null &&
                                      Constants.prefs.getString(Constants.profileImg).isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(authController.profileImg.toString()),
                                      fit: BoxFit.cover,
                                    )
                                  : null
                              : DecorationImage(
                                  image: NetworkImage(authController.profileImg.toString()),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: (Constants.prefs != null &&
                                Constants.prefs.getString(Constants.profileImg).toString().isEmpty &&
                                Constants.prefs.getString(Constants.userName).toString().isNotEmpty)
                            ? Container(
                                height: 45.h,
                                width: 45.w,
                                alignment: Alignment.center,
                                child: Text(
                                  Constants.userName.isEmpty
                                      ? authController.userName.value.substring(0, 1)
                                      : Constants.prefs.getString(Constants.userName).substring(0, 1),
                                  style: TextStyle(fontSize: 35.sp, color: bg_purple),
                                ),
                              )
                            : const SizedBox(),
                      ))),
                  Text(
                    'Let\'s Chat',
                    style: TextStyle(color: white, fontSize: 18.sp),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UsersListScreen()));
                      },
                      child: Icon(
                        Icons.people,
                        color: white,
                      ))
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection(Constants.users).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<UserModel> user = [];
                      snapshot.data!.docs.forEach((element) {
                        user.add(UserModel.fromJson(element.data()));
                      });
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: user.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Get.to(() => ChatScreen(userData: user[index])),
                              child: Column(
                                children: [
                                  Container(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.deepPurple.withOpacity(0.2), borderRadius: BorderRadius.circular(18.r)),
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                                    margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            user[index].profileImg != null
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(30.r),
                                                    child: Image.network(
                                                      user[index].profileImg.toString(),
                                                      fit: BoxFit.cover,
                                                      width: 55.w,
                                                      height: 55.h,
                                                      loadingBuilder:
                                                          (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                        if (loadingProgress == null) return child;
                                                        return Container(
                                                          width: 55.w,
                                                          height: 55.h,
                                                          color: Colors.white,
                                                          child: Center(
                                                            child: CircularProgressIndicator(
                                                              color: Colors.deepPurple,
                                                              value: loadingProgress.expectedTotalBytes != null
                                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                                      loadingProgress.expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder: (context, object, stackTrace) {
                                                        return Container(
                                                            height: 55.w,
                                                            width: 55.w,
                                                            alignment: Alignment.center,
                                                            color: purple_secondary,
                                                            child: Text(
                                                              user[index].userName.toString().substring(0, 1),
                                                              style: TextStyle(fontSize: 35.sp, color: white),
                                                            ));
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    height: 55.h,
                                                    width: 55.w,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      user[index].userName.toString().substring(0, 1),
                                                      style: TextStyle(fontSize: 35.sp, color: white),
                                                    )),
                                            SizedBox(
                                              width: 20.h,
                                            ),
                                            Text(
                                              user[index].userName.toString(),
                                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.deepPurple,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: EdgeInsets.all(8.w),
                                          child: Text(
                                            '1',
                                            style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.deepPurple.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            );
                          });
                      // ListView.builder(
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
      ),
    );
  }
}
