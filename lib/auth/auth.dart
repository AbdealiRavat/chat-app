// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../pages/auth_pages/login_page.dart';
// import '../pages/home_page.dart';
//
// class AuthPage extends StatelessWidget {
//   AuthPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             FirebaseFirestore.instance
//                 .collection("Users")
//                 .doc(FirebaseAuth.instance.currentUser!.email)
//                 .get()
//                 .then((DocumentSnapshot doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               if (data['isFirstTime']) {
//                 return const LoginPage();
//               } else {
//                 return HomePage();
//               }
//             });
//             // data = FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.email).snapshots()
//             //     as Map<String, dynamic>?;
//             // print(data?['isFirstTime']);
//             // print('data');
//             // if (data?['isFirstTime']) {
//             //   print('data2');
//             //   print(data);
//             //   return LoginPage();
//             // } else {
//             return HomePage();
//             // }
//             //     .then(
//             //   (DocumentSnapshot doc) {
//             //
//             //   },
//             // );
//             // return LoginPage();
//           } else {
//             return const LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:chat_app/utlis/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../pages/home_page.dart';
import 'auth_pages/login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      checkSignIn();
    });
    super.initState();
  }

  checkSignIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAll(() => const HomePage());
    } else {
      Get.offAll(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: purple_secondary,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/logo.png',
              width: 100.h,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              'The Wall',
              style: TextStyle(fontSize: 35.sp, color: white),
            ),
            // CircularProgressIndicator(
            //   color: Colors.deepPurple,
            //   backgroundColor: Colors.transparent,
            // ),
          ],
        ))

        // StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       // Still waiting for the authentication state to be determined.
        //       return const
        //     }
        //
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       return FutureBuilder(
        //         future: FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get(),
        //         builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> docSnapshot) {
        //           if (docSnapshot.connectionState == ConnectionState.waiting) {
        //             return const Center(
        //               child: CircularProgressIndicator(
        //                 color: Colors.deepPurple,
        //                 backgroundColor: Colors.transparent,
        //               ),
        //             ); // Loading indicator while fetching data.
        //           }
        //
        //           final data = docSnapshot.data?.data() as Map<String, dynamic>;
        //
        //           if (data != null && data['isFirstTime'] == true) {
        //             return const LoginPage();
        //           } else {
        //             return const HomePage();
        //           }
        //         },
        //       );
        //     } else {
        //       return Container();
        //     }
        //   },
        // ),
        );
  }
}
