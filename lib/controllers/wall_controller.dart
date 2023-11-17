import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utlis/constants.dart';

class WallController extends GetxController {
  postMessage(textController, userData) async {
    print(userData[Constants.userName].toString());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userName = prefs.getString('userName');
    if (textController.text.isNotEmpty &&
        textController.text.trim().isNotEmpty) {
      FirebaseFirestore.instance
          .collection(Constants.userChats)
          .doc(userData[Constants.userName].toString())
          .collection(userData[Constants.userName])
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'UserEmail': FirebaseAuth.instance.currentUser!.email,
        'UserName': userName,
        'Message': textController.text.trimLeft().trimRight(),
        'imgMessage': '',
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
      print('message posted');
      textController.clear();
    }
  }
}
