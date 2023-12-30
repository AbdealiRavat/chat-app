class MessageModel {
  String? id;
  String? message;
  String? imgMessage;
  String? msgFrom;
  String? msgTo;
  String? timeStamp;
  List<Read>? read;

  MessageModel({
    this.id,
    this.message,
    this.imgMessage,
    this.msgFrom,
    this.msgTo,
    this.timeStamp,
    this.read,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    List<Read> tempList = [];
    id = json['id'];
    message = json['message'];
    imgMessage = json['imgMessage'];
    msgFrom = json['msgFrom'];
    msgTo = json['msgTo'];
    timeStamp = json['timeStamp'];
    if (json['read'] != null && json['read'].length != 0) {
      json["read"].forEach((element) {
        tempList.add(Read.fromJson(element));
      });
    }
    read = tempList;
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    List temp = [];
    json['id'] = id;
    json['message'] = message;
    json['imgMessage'] = imgMessage;
    json['msgFrom'] = msgFrom;
    json['msgTo'] = msgTo;
    json['timeStamp'] = timeStamp;
    read!.forEach((element) {
      temp.add(element.toJson());
    });

    json['read'] = temp;
    return json;
  }
}

class Read {
  bool? isRead;
  String? readTime;
  String? readBy;

  Read({this.isRead, this.readTime, this.readBy});

  Read.fromJson(Map<String, dynamic> json) {
    isRead = json['isRead'];
    readTime = json['readTime'];
    readBy = json['readBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['isRead'] = isRead;
    json['readTime'] = readTime;
    json['readBy'] = readBy;
    return json;
  }
}
