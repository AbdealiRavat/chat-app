import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/users_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
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
      await Constants.initializePref();
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
      authController.setStatus("Offline");
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
        body: Stack(
          children: [
            // Positioned(
            //   right: 0,
            //   top: 0,
            //   height: MediaQuery.sizeOf(context).height * 1,
            //   child: Image.asset(
            //     'asset/bg.jpg',
            //     height: 150.h,
            //
            //     fit: BoxFit.cover,
            //     // height: MediaQuery.sizeOf(context).height * 1,
            //     // width: MediaQuery.sizeOf(context).height * 1,
            //   ),
            // ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 25.h, 20.w, 0.h),
                  height: 100.h,
                  decoration: BoxDecoration(color: bg_purple, borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Obx(() =>
                      InkWell(
                        onTap: () {
                          Get.to(() => const ProfilePage());
                          // authController.signOut(context);
                        },
                        child: Container(
                          height: 45.h,
                          width: 45.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: const AspectRatio(
                                aspectRatio: 1.6,
                                child: BlurHash(
                                  hash: 'L5H2EC=PM+yV0g-mq.wG9c010J}I',
                                  imageFit: BoxFit.cover,
                                  image:
                                      'https://firebasestorage.googleapis.com/v0/b/the-wall-e0bf3.appspot.com/o/images%2FIVmddrHqiLMwh1N3t6kXh0JpfKt1?alt=media&token=6eb2402c-a1ea-4215-bb91-65da7427bddc',
                                )),
                          ),
                        ),

                        // Container(
                        //   height: 45.h,
                        //   width: 45.w,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(width: 1.5.w, color: white, strokeAlign: BorderSide.strokeAlignOutside),
                        //     shape: BoxShape.circle,
                        //     color: authController.profileImg.isEmpty ? white.withOpacity(0.9) : white.withOpacity(0.5),
                        //     image: authController.profileImg.isEmpty
                        //         ? Constants.prefs != null &&
                        //                 Constants.prefs.getString(Constants.profileImg) != null &&
                        //                 Constants.prefs.getString(Constants.profileImg).isNotEmpty
                        //             ? DecorationImage(
                        //                 image: NetworkImage(Constants.prefs.getString(Constants.profileImg)!),
                        //                 fit: BoxFit.cover,
                        //               )
                        //             : null
                        //         : DecorationImage(
                        //             image: NetworkImage(authController.profileImg.toString()),
                        //             fit: BoxFit.cover,
                        //           ),
                        //   ),
                        //   child: (Constants.prefs != null &&
                        //           Constants.prefs.getString(Constants.profileImg).toString().isEmpty &&
                        //           Constants.prefs.getString(Constants.userName).toString().isNotEmpty)
                        //       ? Container(
                        //           height: 45.h,
                        //           width: 45.w,
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             Constants.userName.isEmpty
                        //                 ? authController.userName.value.substring(0, 1)
                        //                 : Constants.prefs.getString(Constants.userName).substring(0, 1),
                        //             style: TextStyle(fontSize: 35.sp, color: bg_purple),
                        //           ),
                        //         )
                        //       : const SizedBox(),
                        // )
                      )
                      // )
                      ,
                      Text(
                        'Let\'s Chat',
                        style: TextStyle(color: white, fontSize: 18.sp),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UsersInfoScreen()));
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
                      stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                QueryDocumentSnapshot<Map<String, dynamic>> data = snapshot.data!.docs[index];
                                return InkWell(
                                  onTap: () => Get.to(() => ChatScreen(userData: data)),
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.deepPurple.withOpacity(0.2), borderRadius: BorderRadius.circular(18.r)),
                                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.h),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            data['profileImg'] != null
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(30.r),
                                                    child: Image.network(
                                                      data[Constants.profileImg].toString(),
                                                      fit: BoxFit.cover,
                                                      width: 60.w,
                                                      height: 60.h,
                                                      loadingBuilder:
                                                          (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                        if (loadingProgress == null) return child;
                                                        return Container(
                                                          width: 60.w,
                                                          height: 60.h,
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
                                                            height: 60.h,
                                                            width: 60.w,
                                                            alignment: Alignment.center,
                                                            color: purple_secondary,
                                                            child: Text(
                                                              data[Constants.userName].toString().substring(0, 1),
                                                              style: TextStyle(fontSize: 40.sp, color: white),
                                                            ));
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    height: 60.h,
                                                    width: 60.w,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      data[Constants.userName].toString().substring(0, 1),
                                                      style: TextStyle(fontSize: 40.sp, color: white),
                                                    )),
                                            Positioned(
                                              right: 0.w,
                                              child: Icon(
                                                Icons.circle,
                                                size: 15.h,
                                                color: data['status'] == "Online" ? Colors.green : Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20.h,
                                        ),
                                        Expanded(
                                          child: Text(
                                            data['userName'].toString(),
                                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
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
          ],
        ),
      ),
    );
  }
}
