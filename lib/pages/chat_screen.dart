import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/user_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/cards/wall_post.dart';
import '../components/loaders/loader.dart';
import '../components/post_text_field.dart';
import '../controllers/auth_controller.dart';
import '../controllers/wall_controller.dart';
import '../utlis/colors.dart';
import '../utlis/constants.dart';

class ChatScreen extends StatefulWidget {
  UserModel userData;
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
    wallController.generateChatId(currentUser.currentUser!.uid, widget.userData.id);
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
      child: SafeArea(
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
                  // height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration:
                        BoxDecoration(color: bg_purple, borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => UserInfoScreen(
                                      userData: widget.userData,
                                    ));
                              },
                              child: buildProfileImage(),
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  widget.userData.userName.toString(),
                                  style: TextStyle(color: white, fontSize: 18.sp, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.userData.status == 'Online'
                                      ? widget.userData.status.toString()
                                      : DateFormat('hh:mm a').format(DateTime.parse(widget.userData.status.toString())),
                                  style: TextStyle(color: white, fontSize: 14.sp),
                                )
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.more_vert_rounded,
                          color: white,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() => StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(Constants.userChats)
                              .doc(wallController.chatId.value)
                              .collection(wallController.chatId.value)
                              .orderBy(Constants.timeStamp, descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<MessageModel> chatData = [];
                              snapshot.data!.docs.forEach((element) {
                                chatData.add(MessageModel.fromJson(element.data()));
                              });
                              return chatData.isEmpty
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
                                              decoration:
                                                  BoxDecoration(color: deep_purple, borderRadius: BorderRadius.circular(5)),
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
                                          itemCount: chatData.length,
                                          controller: listViewController,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              // onLongPress: () {
                                              //   if (widget.userData['isSuperAdmin']) {
                                              //     showGeneralDialog(
                                              //         context: context,
                                              //         transitionBuilder: (context, a1, a2, widget) {
                                              //           return Transform.scale(
                                              //             scale: a1.value,
                                              //             child: Opacity(
                                              //               opacity: a1.value,
                                              //               child: widget,
                                              //             ),
                                              //           );
                                              //         },
                                              //         pageBuilder: (context, a1, a2) => AlertBox(onTap: () {
                                              //               Navigator.pop(context);
                                              //               FirebaseFirestore.instance
                                              //                   .collection("User Posts")
                                              //                   .doc(post.id)
                                              //                   .delete();
                                              //             }));
                                              //   }
                                              // },
                                              onTap: () {
                                                setState(() {});
                                                showTime = !showTime;
                                              },
                                              child: WallPost(
                                                message: chatData[index].message.toString(),
                                                imgPost: chatData[index].imgMessage.toString(),
                                                currentUser: chatData[index].msgFrom.toString(),
                                                rcvUser: chatData[index].msgTo.toString(),
                                                timeStamp: chatData[index].timeStamp.toString(),
                                                showTime: showTime,
                                                postId: chatData[index].id.toString(),
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
                      msgTo: widget.userData.id)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileImage() {
    final profileImgUrl = widget.userData.profileImg ?? null;

    if (profileImgUrl != null && Uri.parse(profileImgUrl).isAbsolute) {
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
