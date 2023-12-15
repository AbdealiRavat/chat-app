import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../components/cards/wall_post.dart';
import '../components/common_widgets/alert_box.dart';
import '../components/loaders/loader.dart';
import '../components/post_text_field.dart';
import '../controllers/auth_controller.dart';
import '../controllers/wall_controller.dart';
import '../utlis/colors.dart';
import '../utlis/constants.dart';

class ChatScreen extends StatefulWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> userData;
  ChatScreen({super.key, required this.userData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final currentUser = FirebaseAuth.instance;
  TextEditingController textController = TextEditingController();
  ScrollController listViewController = ScrollController();
  String? data;
  bool showTime = false;
  FocusNode focusNode = FocusNode();
  WallController wallController = Get.put(WallController());
  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    wallController.generateChatId(currentUser.currentUser!.uid, widget.userData['id']);
    Future.microtask(() async {
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      // String? token = await FirebaseMessaging.instance.getToken();
      WidgetsBinding.instance.addObserver(this);
      Constants.initializePref();
      // var temp = await FirebaseStorage.instance.ref().child('defaultImg').child('3135715.png').getDownloadURL();
      // setState(() {
      //   data = temp;
      // });
      // print(token.toString());
    });
    super.initState();
  }

  scrollDown() {
    listViewController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  var rcUserName;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[200],

        body:
            // Column(
            // children: [
            // Expanded(
            //   child:
            Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              height: MediaQuery.sizeOf(context).height,
              child: Image.asset(
                'asset/bg.jpg',
                height: 150.h,

                fit: BoxFit.cover,
                // height: MediaQuery.sizeOf(context).height * 1,
                // width: MediaQuery.sizeOf(context).height * 1,
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  alignment: Alignment.bottomCenter,
                  height: 90.h,
                  decoration: BoxDecoration(color: bg_purple, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          // Get.to(() => const ProfilePage());
                        },
                        child: buildProfileImage(),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        widget.userData[Constants.userName],
                        style: TextStyle(color: white, fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() => StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(Constants.userChats)
                            .doc(wallController.chatId.value)
                            .collection(wallController.chatId.value)
                            .orderBy("TimeStamp", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!.docs.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'No Data Found!',
                                          style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            focusNode.requestFocus();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(color: deep_purple, borderRadius: BorderRadius.circular(5)),
                                            child: Text(
                                              'Start Conversation',
                                              style: TextStyle(fontSize: 16.sp, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(top: 10.h),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: snapshot.data!.docs.length,
                                        controller: listViewController,
                                        itemBuilder: (context, index) {
                                          final post = snapshot.data!.docs[index];

                                          return InkWell(
                                            onLongPress: () {
                                              if (widget.userData['isSuperAdmin']) {
                                                showGeneralDialog(
                                                    context: context,
                                                    transitionBuilder: (context, a1, a2, widget) {
                                                      return Transform.scale(
                                                        scale: a1.value,
                                                        child: Opacity(
                                                          opacity: a1.value,
                                                          child: widget,
                                                        ),
                                                      );
                                                    },
                                                    pageBuilder: (context, a1, a2) => AlertBox(onTap: () {
                                                          Navigator.pop(context);
                                                          FirebaseFirestore.instance
                                                              .collection("User Posts")
                                                              .doc(post.id)
                                                              .delete();
                                                        }));
                                              }
                                            },
                                            onTap: () {
                                              setState(() {});
                                              showTime = !showTime;
                                            },
                                            child: WallPost(
                                              message: post['Message'] ?? '',
                                              imgPost: post['imgMessage'] ?? '',
                                              currentUser: post['msgFrom'],
                                              rcvUser: post['msgTo'],
                                              // userName: post['UserName'],
                                              timeStamp: post['TimeStamp'],
                                              showTime: showTime,
                                              postId: post.id,
                                              // likes: List<String>.from(post['Likes'] ?? []),
                                              // isLiked: post['Likes'].contains(currentUser.currentUser!.email),
                                            ),
                                          );
                                        }),
                                  );
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Error'));
                          }
                          return const Center(child: Loader());
                        },
                      )),
                ),
                PostTextField(
                    controller: textController,
                    focusNode: focusNode,
                    hintText: 'Enter Message',
                    onPressed: () {
                      wallController.postMessage(textController, widget.userData);
                      scrollDown();
                    },
                    chatId: wallController.chatId.value,
                    msgTo: widget.userData['id'])
              ],
            ),
          ],
        ),
        // ),
        // const SizedBox(
        //   height: 30,
        // ),
        // RatingBar(
        //   initialRating: 3,
        //   minRating: 0,
        //   direction: Axis.horizontal,
        //   allowHalfRating: true,
        //   itemCount: 5,
        //   glow: true,
        //   // ignoreGestures: true,
        //   ratingWidget: RatingWidget(
        //     full: Icon(
        //       Icons.star,
        //       color: Colors.amber,
        //     ),
        //     half: Icon(
        //       Icons.star_half,
        //       color: Colors.amber,
        //     ),
        //     empty: Icon(
        //       Icons.star_border,
        //       color: Colors.amber,
        //     ),
        //   ),
        //   onRatingUpdate: (rating) {
        //     print(rating);
        //   },
        // ),
        // const SizedBox(
        //   height: 30,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const Text('Hello'),
        //     const SizedBox(
        //       width: 20,
        //     ),
        //     Text(currentUser.email.toString()),
        //   ],
        // ),
        // ],
        // ),
      ),
    );
  }

  Widget buildProfileImage() {
    final profileImgUrl = widget.userData.data().containsKey(Constants.profileImg)
        ? widget.userData.data()[Constants.profileImg]?.toString()
        : null;

    if (profileImgUrl != null && Uri.parse(profileImgUrl).isAbsolute) {
      print("Profile Image URL: $profileImgUrl");

      return CachedNetworkImage(
        imageUrl: profileImgUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: 45.h,
          width: 45.w,
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
          widget.userData[Constants.userName].toString().substring(0, 1),
          style: TextStyle(fontSize: 35.sp, color: bg_purple),
        ),
      );
    }
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
