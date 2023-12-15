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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import 'auth_pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //   Still waiting for the authentication state to be determined.
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.deepPurple,
              backgroundColor: Colors.transparent,
            )); // You can replace this with a loading indicator.
          }

          if (snapshot.hasData && snapshot.data != null) {
            return FutureBuilder(
              future: FirebaseFirestore.instance.collection("Users").doc(snapshot.data!.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> docSnapshot) {
                if (docSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                      backgroundColor: Colors.transparent,
                    ),
                  ); // Loading indicator while fetching data.
                }

                final data = docSnapshot.data?.data() as Map<String, dynamic>;

                if (data['isFirstTime'] == true) {
                  return const LoginPage();
                } else {
                  return const HomePage();
                }
              },
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
