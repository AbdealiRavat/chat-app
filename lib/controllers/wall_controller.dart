import 'dart:io';

import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
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

  postMessage(textController, UserModel userData) async {
    MessageModel messageModel = MessageModel(
        id: chatId.value,
        message: textController.text.trimLeft().trimRight(),
        imgMessage: '',
        msgFrom: FirebaseAuth.instance.currentUser!.uid,
        msgTo: userData.id.toString(),
        timeStamp: DateTime.now().toString(),
        isRead: false);
    if (textController.text.isNotEmpty && textController.text.trim().isNotEmpty) {
      FirebaseFirestore.instance
          .collection(Constants.userChats)
          .doc(chatId.value)
          .collection(chatId.value)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(messageModel.toJson());
      print('message posted');
      textController.clear();
    }
  }

  getImage(type, String msgTo) async {
    var image = await ImagePicker().pickImage(source: type == 'Camera' ? ImageSource.camera : ImageSource.gallery);

    if (image == null) return;
    Get.back();

    Reference imageRef = FirebaseStorage.instance
        .ref()
        .child('postImages')
        .child(chatId.toString())
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    await imageRef.putFile(
        File(image.path),
        SettableMetadata(
          contentType: "image/jpeg",
        ));
    try {
      String imgUrl = await imageRef.getDownloadURL();
      MessageModel messageModel = MessageModel(
          id: chatId.value,
          message: '',
          imgMessage: imgUrl,
          msgFrom: FirebaseAuth.instance.currentUser!.uid,
          msgTo: msgTo.toString(),
          timeStamp: DateTime.now().toString(),
          isRead: false);
      FirebaseFirestore.instance
          .collection(Constants.userChats)
          .doc(chatId.toString())
          .collection(chatId.toString())
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(messageModel.toJson());
    } catch (e) {
      print(e.toString());
    }
  }
}
