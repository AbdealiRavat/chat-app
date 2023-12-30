import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/user_model.dart';
import '../../utlis/colors.dart';

class UsersListTile extends StatelessWidget {
  UserModel userData;
  UsersListTile({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  userData.profileImg != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: Image.network(
                            userData.profileImg.toString(),
                            fit: BoxFit.cover,
                            width: 55.w,
                            height: 55.h,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 55.w,
                                height: 55.h,
                                color: Colors.white,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.deepPurple,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
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
                                    userData.userName.toString().substring(0, 1),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 33.sp, color: white),
                                  ));
                            },
                          ),
                        )
                      : Container(
                          height: 55.h,
                          width: 55.w,
                          // alignment: Alignment.center,
                          child: Text(
                            userData.userName.toString().substring(0, 1),
                            style: TextStyle(fontSize: 35.sp, color: white),
                          )),
                  SizedBox(
                    width: 20.h,
                  ),
                  Text(
                    userData.id == FirebaseAuth.instance.currentUser!.uid
                        ? '${userData.userName} (You)'
                        : userData.userName.toString(),
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(6.w),
                child: Text(
                  '',
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
    );
  }
}
