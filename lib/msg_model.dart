class MessageModel {
  String? message;
  String? time;
  String? id;

  MessageModel({this.message, this.time});

  MessageModel.fromJson(Map<String, dynamic> json, this.message, this.time) {
    message = json["message"];
    time = json['time'];
    id = json["id"];
  }
}
