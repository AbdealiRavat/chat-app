// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../components/common_widgets/button.dart';
import '../../components/common_widgets/text_field.dart';
import '../../controllers/auth_controller.dart';
import '../../utlis/colors.dart';

class RegisterPage extends StatefulWidget {
  // final Function()? onTap;
  const RegisterPage({
    super.key,
    //  required this.onTap
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailTextController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    Future.microtask(() {
      authController.errorMessage.value = '';
      authController.isPasswordEmpty.value = false;
      authController.didPasswordMatch.value = true;

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
                  Image.asset(
                    'asset/chats.png',
                    height: 150.h,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    'Let\'s create your account',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    // focusNode: emailFocusNode,
                    // focusChange: () {
                    //   emailFocusNode.unfocus();
                    //   FocusScope.of(context).requestFocus(passwordFocusNode);
                    // },
                    tColor: Colors.white,
                    obscureText: false,
                    isHidden: false,
                    isPassword: false,
                  ),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    // focusNode: passwordFocusNode,
                    // focusChange: () {
                    //   passwordFocusNode.unfocus();
                    //   FocusScope.of(context)
                    //       .requestFocus(confirmPasswordFocusNode);
                    // },
                    tColor: Colors.white,
                    obscureText: true,
                    isHidden: true,
                    isPassword: true,
                  ),
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      // focusNode: confirmPasswordFocusNode,
                      // focusChange: () {
                      //   confirmPasswordFocusNode.unfocus();
                      // },
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
                                    : !authController.didPasswordMatch.value
                                        ? 'Password didn\'t match'
                                        : authController.errorMessage.value.isNotEmpty
                                            ? authController.errorMessage.value.toString()
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
                          final confirmPassword = confirmPasswordController.text;

                          authController.isEmailEmpty.value = email.isEmpty;
                          authController.isPasswordEmpty.value = password.isEmpty;
                          authController.didPasswordMatch.value = (password == confirmPassword);

                          if (email.isNotEmpty && password.isNotEmpty && (password == confirmPassword)) {
                            authController.signUp(context, emailTextController, passwordController, confirmPasswordController);
                          }
                        },
                        text: 'Sign Up',
                        isLoading: authController.isLoading.value,
                      )),
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
                        Text('Already a member?', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                        SizedBox(width: 15.w),
                        InkWell(
                            onTap: () {
                              Get.offAll(() => RegisterPage());
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => LoginPage()),
                              // );
                            },
                            child:
                                Text('Login here', style: TextStyle(color: white, fontSize: 16.sp, fontWeight: FontWeight.w900))),
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
