import 'dart:io';

import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_model.dart';
import '../utlis/constants.dart';

class WallController extends GetxController {
  RxString chatId = "".obs;
  RxList usersList = [].obs;

  generateChatId(currentUserId, peerId) {
    if (currentUserId.compareTo(peerId) > 0) {
      chatId('$currentUserId-$peerId');
    } else {
      chatId('$peerId-$currentUserId');
    }
  }

  postMessage(textController, UserModel userData) async {
    var timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    MessageModel messageModel = MessageModel(
        id: timeStamp,
        message: textController.text.trimLeft().trimRight(),
        imgMessage: '',
        msgFrom: FirebaseAuth.instance.currentUser!.uid,
        msgTo: userData.id.toString(),
        timeStamp: timeStamp,
        isRead: false);
    if (textController.text.isNotEmpty && textController.text.trim().isNotEmpty) {
      FirebaseFirestore.instance
          .collection(Constants.userChats)
          .doc(chatId.value)
          .collection(chatId.value)
          .doc(timeStamp)
          .set(messageModel.toJson());

      // await FirebaseFirestore.instance
      //     .collection(Constants.users)
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .get()
      //     .then((DocumentSnapshot doc) async {
      //   UserModel user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      // });

      // ChattingWith temp = ChattingWith(lastMessageTime: timeStamp, userId: userData.id.toString());
      //
      // FirebaseFirestore.instance.collection(Constants.users).doc(FirebaseAuth.instance.currentUser!.uid).update({
      //   'chattingWith': FieldValue.arrayUnion([temp.toJson()])
      // });
      //
      // ChattingWith temp2 = ChattingWith(lastMessageTime: timeStamp, userId: FirebaseAuth.instance.currentUser!.uid);
      //
      // FirebaseFirestore.instance.collection(Constants.users).doc(userData.id).update({
      //   'chattingWith': FieldValue.arrayUnion([temp2.toJson()])
      // });
      // print('message posted');
      textController.clear();
    }
  }

  getImage(type, String msgTo) async {
    var timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    var image = await ImagePicker().pickImage(source: type == 'Camera' ? ImageSource.camera : ImageSource.gallery);

    if (image == null) return;
    Get.back();

    Reference imageRef = FirebaseStorage.instance.ref().child('postImages').child(chatId.toString()).child(timeStamp);
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
          timeStamp: timeStamp,
          isRead: false);
      FirebaseFirestore.instance
          .collection(Constants.userChats)
          .doc(chatId.toString())
          .collection(chatId.toString())
          .doc(timeStamp)
          .set(messageModel.toJson());
    } catch (e) {
      // print(e.toString());
      const Center(child: Text('error'));
    }
  }
}
