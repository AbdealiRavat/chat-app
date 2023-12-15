import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String currentUser;
  final String rcvUser;
  // final String userName;
  final String postId;
  // List<String> likes;
  // final bool isLiked;
  final Timestamp timeStamp;
  bool showTime;
  String imgPost;

  WallPost({
    super.key,
    required this.message,
    required this.currentUser,
    required this.rcvUser,
    required this.postId,
    // required this.likes,
    // required this.isLiked,
    required this.timeStamp,
    required this.showTime,
    required this.imgPost,
    // required this.userName,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
  }

  // void toggleLike() {
  //   DocumentReference postRef = FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
  //   if (!widget.isLiked) {
  //     postRef.update({
  //       'Likes': FieldValue.arrayUnion([currentUser.email])
  //     });
  //   } else {
  //     postRef.update({
  //       'Likes': FieldValue.arrayRemove([currentUser.email])
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (currentUser.uid == widget.currentUser ? Alignment.topRight : Alignment.topLeft),
      child: Column(
        crossAxisAlignment: currentUser.uid == widget.currentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.7,
              minWidth: MediaQuery.sizeOf(context).width * 0.15,
            ),
            decoration: BoxDecoration(
                color: currentUser.uid == widget.currentUser ? Colors.deepPurple.shade100 : Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.blueGrey.shade50,
                      blurRadius: currentUser.uid == widget.currentUser ? 0 : 3,
                      offset: currentUser.uid == widget.currentUser ? const Offset(0, 0) : const Offset(0.8, 1.1),
                      spreadRadius: 0.1)
                ],
                borderRadius: BorderRadius.circular(10.r)),
            // padding: EdgeInsets.all(16),
            //
            padding: widget.imgPost.isEmpty
                ? EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h)
                : EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
            margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 6.h, bottom: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicWidth(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  // currentUser.uid == widget.currentUser
                  //     ? const SizedBox()
                  //     : Padding(
                  //         padding: EdgeInsets.only(bottom: 12.h, left: 2.w),
                  //         child: Text(widget.userName,
                  //             style: TextStyle(
                  //               color: deep_purple,
                  //             )),
                  //       ),
                  widget.imgPost.isEmpty
                      ? Text(
                          widget.message.toString(),
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey[800]),
                        )
                      : Container(
                          constraints: const BoxConstraints(
                            minHeight: 50,
                            maxHeight: 200,
                            minWidth: double.infinity,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.network(
                              widget.imgPost,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ])),
              ],
            ),
          ),
          // widget.showTime
          //     ? SizedBox(
          //         height: 0.h,
          //       )
          //     : SizedBox(),
          widget.showTime
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    // timeago.format(widget.timeStamp.toDate(), allowFromNow: true),
                    DateFormat('MMM d, h:mm a').format(widget.timeStamp.toDate()),
                    style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w400, color: Colors.grey.shade700),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
    //   Container(
    //   // width: MediaQuery.of(context).size.width * 1,
    //   // height: 40,
    //   // margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
    //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    //   // alignment: currentUser.email == widget.user ? Alignment.centerRight : Alignment.centerLeft,
    //   margin: currentUser.email != widget.user
    //       ? EdgeInsets.only(right: 50.w, top: 6.h, bottom: 6.h, left: 20.w)
    //       : EdgeInsets.only(left: 50.w, top: 6.h, bottom: 6.h, right: 20.w),
    //   // constraints: BoxConstraints(
    //   //   maxWidth: MediaQuery.sizeOf(context).width * 0.2,
    //   // ),
    //   decoration: BoxDecoration(
    //       color: currentUser.email == widget.user ? Colors.deepPurple.withOpacity(0.1) : Colors.blueGrey.withOpacity(0.08),
    //       borderRadius: BorderRadius.circular(20.r)),
    //   // decoration: BoxDecoration(
    //   //     color: currentUser.email == widget.user ? Colors.deepPurple.withOpacity(0.1) : Colors.blueGrey.withOpacity(0.05),
    //   //     borderRadius: BorderRadius.circular(8.r)),
    //   // child: ChatBubble(
    //   //   elevation: 0,
    //   //   alignment: currentUser.email == widget.user ? Alignment.centerRight : Alignment.centerLeft,
    //   //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
    //   //   margin: currentUser.email != widget.user
    //   //       ? EdgeInsets.only(
    //   //           right: 50.w,
    //   //         )
    //   //       : EdgeInsets.only(
    //   //           left: 50.w,
    //   //         ),
    //   //   backGroundColor:
    //   //       currentUser.email == widget.user ? Colors.deepPurple.withOpacity(0.1) : Colors.blueGrey.withOpacity(0.08),
    //   //   clipper: ChatBubbleClipper2(
    //   //       nipWidth: 10,
    //   //       type: currentUser.email == widget.user ? BubbleType.sendBubble : BubbleType.receiverBubble,
    //   //       radius: 15.r),
    //   // Column(
    //   //   children: [
    //   //     LikesButton(isLiked: widget.isLiked, onTap: toggleLike),
    //   //     SizedBox(
    //   //       height: 5.0.h,
    //   //     ),
    //   //     Text(
    //   //       widget.likes.length.toString(),
    //   //       style: TextStyle(fontSize: 12.sp),
    //   //     )
    //   //   ],
    //   // ),
    //   // // Container(
    //   // //   padding: EdgeInsets.all(10),
    //   // //   decoration:
    //   // //       BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
    //   // //   child: Icon(
    //   // //     Icons.person_rounded,
    //   // //     color: Colors.white,
    //   // //     size: 30,
    //   // //   ),
    //   // // ),
    //   // SizedBox(
    //   //   width: 20.w,
    //   // ),
    //   child:
    //
    //       // Column(
    //       //   crossAxisAlignment: CrossAxisAlignment.start,
    //       //   children: [
    //       //     currentUser.email == widget.user ? SizedBox() : Text(widget.user, style: TextStyle(color: Colors.deepPurple)),
    //       //     currentUser.email == widget.user ? SizedBox() : Divider(),
    //       //     SizedBox(
    //       //       height: 10.h,
    //       //     ),
    //       //     Text(
    //       //       widget.message,
    //       //       style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey[800]),
    //       //     ),
    //       //     SizedBox(
    //       //       height: 10.h,
    //       //     ),
    //       //     Align(
    //       //       alignment: Alignment.bottomRight,
    //       //       child: Text(
    //       //         // timeago.format(widget.timeStamp.toDate(), allowFromNow: true),
    //       //         DateFormat('MMM d, h:mm a').format(widget.timeStamp.toDate()),
    //       //
    //       //         style: TextStyle(fontWeight: FontWeight.w600),
    //       //       ),
    //       //     ),
    //       //   ],
    //       // ),
    //       // ),
    //       Text(
    //     widget.message,
    //     style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey[800]),
    //   ),
    // );
  }
}
