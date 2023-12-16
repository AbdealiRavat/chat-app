class MessageModel {
  String? id;
  String? message;
  String? imgMessage;
  String? msgFrom;
  String? msgTo;
  String? timeStamp;
  bool? isRead;

  MessageModel({
    this.id,
    this.message,
    this.imgMessage,
    this.msgFrom,
    this.msgTo,
    this.timeStamp,
    this.isRead,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    imgMessage = json['imgMessage'];
    msgFrom = json['msgFrom'];
    msgTo = json['msgTo'];
    timeStamp = json['timeStamp'];
    isRead = json['isRead'];
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['message'] = message;
    json['imgMessage'] = imgMessage;
    json['msgFrom'] = msgFrom;
    json['msgTo'] = msgTo;
    json['timeStamp'] = timeStamp;
    json['isRead'] = isRead;

    return json;
  }
}
