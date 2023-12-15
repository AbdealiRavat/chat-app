// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/auth/auth_pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../components/common_widgets/button.dart';
import '../../components/common_widgets/text_field.dart';
import '../../controllers/auth_controller.dart';
import '../../utlis/colors.dart';
import '../../utlis/constants.dart';

class LoginPage extends StatefulWidget {
  // final Function()? onTap;
  const LoginPage({
    super.key,
    //  required this.onTap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    Future.microtask(() {
      Constants.initializePref();
      authController.errorMessage.value = '';
      authController.isPasswordEmpty.value = false;

      authController.isEmailEmpty.value = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: bg_purple,
        body: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              height: MediaQuery.sizeOf(context).height * 1,
              child: Image.asset(
                'asset/bg_img.png',
                fit: BoxFit.cover,
                // height: MediaQuery.sizeOf(context).height * 1,
                // width: MediaQuery.sizeOf(context).height * 1,
              ),
            ),
            Center(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                children: [
                  // Icon(
                  //   Icons.lock,
                  //   size: 130.w,
                  //   color: Colors.white,
                  // ),
                  Image.asset(
                    'asset/chats.png',
                    height: 150.h,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    'Welcome to the Chat App',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  MyTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      focusNode: emailFocusNode,
                      focusChange: () {
                        emailFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      tColor: Colors.white,
                      obscureText: false,
                      isHidden: false,
                      isPassword: false),
                  MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      focusNode: passwordFocusNode,
                      focusChange: () {
                        passwordFocusNode.unfocus();
                      },
                      tColor: Colors.white,
                      obscureText: true,
                      isHidden: true,
                      isPassword: true),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Center(
                          child: Text(
                            authController.isEmailEmpty.value
                                ? 'Enter Valid Email'
                                : authController.isPasswordEmpty.value
                                    ? 'Enter Password'
                                    : authController.errorMessage.value.isNotEmpty
                                        ? "Invalid User Credentials "
                                        : '',
                            style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      )),
                  Obx(() => MyButton(
                      onTap: () {
                        final email = emailTextController.text.trim();
                        final password = passwordController.text;

                        authController.isEmailEmpty.value = email.isEmpty;
                        authController.isPasswordEmpty.value = password.isEmpty;

                        if (email.isNotEmpty && password.isNotEmpty) {
                          authController.signIn(context, emailTextController, passwordController);
                        }
                      },
                      text: 'Login',
                      isLoading: authController.isLoading.value)),
                  Divider(
                    color: white,
                    indent: 70,
                    endIndent: 70,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a member?', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                        SizedBox(
                          width: 15.w,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterPage()),
                              );
                            },
                            child: Text('Register here',
                                style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w900))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
