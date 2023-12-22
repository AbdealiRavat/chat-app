// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'auth/auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // String? token = await FirebaseMessaging.instance.getToken();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            theme: ThemeData(),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.grey.shade900,
              body: AuthPage(),
            ),
          );
        });
  }
}

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   MainPageState createState() => MainPageState();
// }
//
// class MainPageState extends State<MainPage> {
//   @override
//   Widget build(BuildContext context) {
//     return AuthPage();
//   }
// }
