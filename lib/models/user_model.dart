class UserModel {
  String? id;
  String? userName;
  String? email;
  String? profileImg;
  String? bio;
  String? status;
  List<ChattingWith>? chattingWith;
  String? timeStamp;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.profileImg,
    this.bio,
    this.status,
    this.chattingWith,
    this.timeStamp,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    List<ChattingWith> tempList = [];
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    profileImg = json['profileImg'];
    bio = json['bio'];
    status = json['status'];
    if (json['chattingWith'] != null && json['chattingWith'].length != 0) {
      json["chattingWith"].forEach((element) {
        tempList.add(ChattingWith.fromJson(element));
      });
    }
    chattingWith = tempList;
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['userName'] = userName;
    json['email'] = email;
    json['profileImg'] = profileImg;
    json['bio'] = bio;
    json['status'] = status;
    json['chattingWith'] = chattingWith;
    json['timeStamp'] = timeStamp;

    return json;
  }
}

class ChattingWith {
  String? userId;
  String? lastMessageTime;

  ChattingWith({this.userId, this.lastMessageTime});

  ChattingWith.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    lastMessageTime = json['lastMessageTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['userId'] = userId;
    json['lastMessageTime'] = lastMessageTime;
    return json;
  }
}
