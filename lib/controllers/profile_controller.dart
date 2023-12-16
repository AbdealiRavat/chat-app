import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utlis/constants.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool isNameEdit = false.obs;
  RxBool isBioEdit = false.obs;

  RxString userName = ''.obs;
  RxString bio = ''.obs;
  RxString profileImg = ''.obs;
  RxString imgUrl = ''.obs;

  editUserName(String field, userNameController) async {
    isNameEdit.value = !isNameEdit.value;

    if (!isNameEdit.value) {
      if (userNameController.text.isNotEmpty) {
        FirebaseFirestore.instance.collection(Constants.users).doc(FirebaseAuth.instance.currentUser!.uid).update({
          field: userNameController.text.trim(),
        }).then((value) async {
          Fluttertoast.showToast(
              msg: "UserName Updated Successfully",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.deepPurple,
              textColor: Colors.white,
              fontSize: 16.0);

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', userNameController.text);
        });

        // userNameController.clear();
      }
    }
  }

  editBio(String field, bioController) async {
    isBioEdit.value = !isBioEdit.value;

    if (!isBioEdit.value) {
      if (bioController.text.isNotEmpty) {
        FirebaseFirestore.instance.collection(Constants.users).doc(FirebaseAuth.instance.currentUser!.uid).update({
          field: bioController.text.trimRight().trimLeft(),
        }).then((value) async {
          Fluttertoast.showToast(
              msg: "Bio Updated Successfully",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.deepPurple,
              textColor: Colors.white,
              fontSize: 16.sp);

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('bio', bioController.text);
        });
        // bioController.clear();
      }
    }
  }

  getData(userNameController, bioController) async {
    userName.value = await Constants.prefs.getString(Constants.userName);
    bio.value = await Constants.prefs.getString(Constants.bio);
    userNameController.text = Constants.prefs.getString(Constants.userName).toString();
    bioController.text = Constants.prefs.getString(Constants.bio).toString();
  }

  getImage(type, context) async {
    var image = await ImagePicker().pickImage(source: type == 'Camera' ? ImageSource.camera : ImageSource.gallery);

    if (image == null) return;
    Get.back();

    isLoading.value = true;
    Reference imageRef =
        FirebaseStorage.instance.ref().child('profilePic').child(FirebaseAuth.instance.currentUser!.uid.toString());
    await imageRef.putFile(
        File(image.path),
        SettableMetadata(
          contentType: "image/jpeg",
        ));
    try {
      imgUrl.value = await imageRef.getDownloadURL();
      Constants.prefs.setString(Constants.profileImg, imgUrl.toString());
      profileImg(imgUrl.value);
      await FirebaseFirestore.instance.collection(Constants.users).doc(FirebaseAuth.instance.currentUser!.uid).update({
        'profileImg': imgUrl.value,
      }).then((value) => isLoading.value = true);
    } catch (e) {
      print(e.toString());
    }
  }
}
