import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utlis/colors.dart';

class UsersInfoScreen extends StatelessWidget {
  const UsersInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Users List'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.r), bottomRight: Radius.circular(15.r))),
          backgroundColor: bg_purple,
          elevation: 0,
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return Container(
                        decoration:
                            BoxDecoration(color: Colors.deepPurple.withOpacity(0.2), borderRadius: BorderRadius.circular(18.r)),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 7.h),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                // Container(
                                //   height: 60.h,
                                //   width: 60.w,
                                //   decoration: data['profileImg'].isEmpty
                                //       ? const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)
                                //       : BoxDecoration(
                                //           image: DecorationImage(
                                //             image: NetworkImage(data['profileImg']),
                                //             fit: BoxFit.cover,
                                //           ),
                                //           shape: BoxShape.circle,
                                //           color: Colors.white),
                                //   child: data['profileImg'].toString().isEmpty
                                //       ? Container(
                                //           height: 60.h,
                                //           width: 60.w,
                                //           alignment: Alignment.center,
                                //           child: Text(
                                //             data['userName'].toString().substring(0, 1),
                                //             style: TextStyle(fontSize: 35.sp, color: Colors.white),
                                //           ))
                                //       : const SizedBox(),
                                // ),
                                data['profileImg'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(30.r),
                                        child: Image.network(
                                          data['profileImg'].toString(),
                                          fit: BoxFit.cover,
                                          width: 60.w,
                                          height: 60.h,
                                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
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
                                              color: Colors.white,
                                              width: 60.w,
                                              height: 60.h,
                                              child: Icon(
                                                Icons.account_circle_rounded,
                                                size: 60.w,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Icon(
                                        Icons.account_circle,
                                        size: 80.w,
                                        color: Colors.grey,
                                      ),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['userName'].toString(),
                                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                                  ),
                                  const Divider(
                                    color: Colors.deepPurple,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    data.id.toString() ?? '',
                                    style: TextStyle(fontSize: 15.sp),
                                  ),
                                ],
                              ),
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
            }));
  }
}
