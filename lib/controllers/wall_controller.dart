import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utlis/constants.dart';

class WallController extends GetxController {
  RxString chatId = "".obs;

  generateChatId(currentUserId, peerId) {
    if (currentUserId.compareTo(peerId) > 0) {
      chatId('$currentUserId-$peerId');
    } else {
      chatId('$peerId-$currentUserId');
    }
  }

  postMessage(textController, userData) async {
    print(userData[Constants.userName].toString());
    print(userData['id'].toString());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userName = prefs.getString('userName');
    if (textController.text.isNotEmpty && textController.text.trim().isNotEmpty) {
      FirebaseFirestore.instance
          .collection(Constants.userChats)
          .doc(chatId.value)
          .collection(chatId.value)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        // 'UserEmail': FirebaseAuth.instance.currentUser!.email,
        // 'UserName': userName,
        'msgFrom': FirebaseAuth.instance.currentUser!.uid,
        'msgTo': userData['id'].toString(),
        'Message': textController.text.trimLeft().trimRight(),
        'imgMessage': '',
        'TimeStamp': Timestamp.now(),
        // 'Likes': [],
      });
      print('message posted');
      textController.clear();
    }
  }
}
