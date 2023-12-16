class UserModel {
  String? id;
  String? userName;
  String? email;
  String? profileImg;
  String? bio;
  String? status;
  String? timeStamp;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.profileImg,
    this.bio,
    this.status,
    this.timeStamp,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    profileImg = json['profileImg'];
    bio = json['bio'];
    status = json['status'];
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
    json['timeStamp'] = timeStamp;

    return json;
  }
}
