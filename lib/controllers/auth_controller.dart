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

import '../pages/auth_pages/login_page.dart';
import '../pages/home_page.dart';
import '../utlis/constants.dart';

class AuthController extends GetxController {
  RxBool isEmailEmpty = false.obs;
  RxBool isPasswordEmpty = false.obs;
  RxBool didPasswordMatch = true.obs;
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  RxBool isNameEdit = false.obs;
  RxBool isBioEdit = false.obs;

  RxString userName = ''.obs;
  RxString bio = ''.obs;
  RxString profileImg = ''.obs;
  RxString imgUrl = ''.obs;
  void signIn(context, emailTextController, passwordController) async {
    isLoading(true);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailTextController.text.trim(),
              password: passwordController.text.trim())
          .then((value) async {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get()
            .then((DocumentSnapshot doc) async {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'isFirstTime': false});
          final data = doc.data() as Map<String, dynamic>;

          profileImg(data['profileImg'] ?? "");
          userName(data['userName'].toString().capitalizeFirst ?? "");
          await Constants.prefs
              .setString(Constants.userName, data['userName'] ?? "");
          await Constants.prefs.setString(Constants.email, data['email'] ?? "");
          await Constants.prefs.setString(Constants.bio, data['bio'] ?? "");
          await Constants.prefs
              .setString(Constants.profileImg, data['profileImg'] ?? "");
        });
        isLoading(false);
        await Get.offAll(() => const HomePage());
      });
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      print(e.message);
      errorMessage.value = e.message.toString();
    }
  }

  void signUp(context, emailTextController, passwordController,
      confirmPasswordController) async {
    // showDialog(context: context, builder: (context) => Loader());

    isLoading(true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text.trim(),
              password: passwordController.text.trim());
      String userName =
          emailTextController.text.toString().capitalizeFirst!.split('@')[0];
      String email = emailTextController.text.trim();

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'userName': userName,
        'bio': '',
        'profileImg': '',
        'TimeStamp': Timestamp.now(),
        'status': 'Offline',
        'isFirstTime': true,
        'isSuperAdmin': false,
      }).then((value) async {
        Fluttertoast.showToast(
            msg: "User Registered Successfully",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white,
            fontSize: 16.0);
        await Constants.prefs.setString(Constants.userName, userName);

        isLoading(false);
        Get.offAll(() => const LoginPage());
      });
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      errorMessage.value = e.message.toString();
      // displayMessage(e.code);
    }
  }

  editUserName(
      String field, Map<String, dynamic> userData, userNameController) async {
    isNameEdit.value = !isNameEdit.value;

    if (!isNameEdit.value) {
      if (userNameController.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .update({
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

  editBio(String field, Map<String, dynamic> userData, bioController) async {
    isBioEdit.value = !isBioEdit.value;

    if (!isBioEdit.value) {
      if (bioController.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .update({
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
    userNameController.text =
        Constants.prefs.getString(Constants.userName).toString();
    bioController.text = Constants.prefs.getString(Constants.bio).toString();
  }

  setStatus(String status) {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'status': status});
    }
  }

  signOut(context) async {
    setStatus("Offline");
    await Constants.prefs.setString(Constants.userName, '');
    await Constants.prefs.setString(Constants.bio, '');
    await Constants.prefs.setString(Constants.profileImg, '');
    profileImg.value = '';
    await Get.offAll(() => const LoginPage());
    await FirebaseAuth.instance.signOut();
  }

  getImage(type, context) async {
    var image = await ImagePicker().pickImage(
        source: type == 'Camera' ? ImageSource.camera : ImageSource.gallery);
    // File? imageFile;
    // if (image != null) {
    //   imageFile = File(image.path);
    //   var result = await compressFile(imageFile);
    //   var file = File(result!.path);
    //   return file;
    // }

    if (image == null) return;
    Get.back();

    Reference imageRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child(FirebaseAuth.instance.currentUser!.email.toString());
    await imageRef.putFile(
        File(image.path),
        SettableMetadata(
          contentType: "image/jpeg",
        ));
    try {
      imgUrl.value = await imageRef.getDownloadURL();
      Constants.prefs.setString(Constants.profileImg, imgUrl.toString());
      profileImg(imgUrl.value);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        'profileImg': imgUrl.value,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
