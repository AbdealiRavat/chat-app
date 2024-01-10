import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../auth/auth_pages/login_page.dart';
import '../pages/home_page.dart';
import '../utlis/constants.dart';

class AuthController extends GetxController {
  RxBool isEmailEmpty = false.obs;
  RxBool isPasswordEmpty = false.obs;
  RxBool didPasswordMatch = true.obs;
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;
  RxString token = ''.obs;

  RxString userName = ''.obs;
  RxString bio = ''.obs;
  RxString profileImg = ''.obs;
  RxString imgUrl = ''.obs;

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  void signIn(context, emailTextController, passwordController) async {
    isLoading(true);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailTextController.text.trim(), password: passwordController.text.trim())
          .then((value) async {
        FirebaseFirestore.instance
            .collection(Constants.users)
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get()
            .then((DocumentSnapshot doc) async {
          UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
          // print(user);
          profileImg(user.profileImg ?? "");
          userName(user.userName.toString().capitalizeFirst ?? "");
          await Constants.prefs.setString(Constants.userName, user.userName ?? "");
          await Constants.prefs.setString(Constants.email, user.email ?? "");
          await Constants.prefs.setString(Constants.bio, user.bio ?? "");
          await Constants.prefs.setString(Constants.profileImg, user.profileImg ?? "");
        });
        isLoading(false);
        await Get.offAll(() => const HomePage());
      });
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      // print(e.message);
      errorMessage.value = e.message.toString();
    }
  }

  getUserData(initializePref) async {
    var temp = await initializePref;
    profileImg(temp.getString(Constants.profileImg.toString()));
  }

  void signUp(context, emailTextController, passwordController, confirmPasswordController) async {
    // showDialog(context: context, builder: (context) => Loader());

    isLoading(true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text.trim(), password: passwordController.text.trim());
      String userName = emailTextController.text.toString().capitalizeFirst!.split('@')[0];
      String email = emailTextController.text.trim();
      UserModel userData = UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          userName: userName,
          bio: '',
          email: email,
          profileImg: '',
          status: DateTime.now().toString(),
          fcmToken: '',
          timeStamp: DateTime.now().toString(),
          chattingWith: null);
      await FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(userCredential.user!.uid)
          .set(userData.toJson())
          .then((value) async {
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

  setStatus(String status) {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'status': status,
      });
    }
  }

  Future<void> getToken() async {
    await messaging.requestPermission();

    await messaging.getToken().then((val) async {
      if (val != null) {
        token.value = val.toString();
        if (FirebaseAuth.instance.currentUser != null) {
          FirebaseFirestore.instance
              .collection(Constants.users)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'fcmToken': val.toString(),
          });
        }
        await Constants.prefs.setString('fcmToken', val.toString());
      }
    });
    // print(token);
  }

  setToken() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection(Constants.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'fcmToken': token.value,
      });
    }
  }

  signOut(context) async {
    setStatus(DateTime.now().toString());
    await Get.offAll(() => const LoginPage());
    Constants.prefs.setString(Constants.userName, '');
    Constants.prefs.setString(Constants.bio, '');
    Constants.prefs.setString(Constants.profileImg, '');
    profileImg.value = '';
    await FirebaseAuth.instance.signOut();
  }
}
