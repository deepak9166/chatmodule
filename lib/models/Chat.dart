import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  List<UserList> dataList;
  ChatUser({this.dataList});

  ChatUser.fromJson(QuerySnapshot<Object> json) {
    // //print("in state model $json");
    var subjectList = json.docs;
    dataList = subjectList.map((item) => UserList.fromJson(item)).toList();
  }
}

class UserList {
  String name, lastMessage, image;
  String lastSceen;
  bool isActive;
  String id;
  UserList({
    this.name,
    this.lastMessage,
    this.image,
    this.lastSceen,
    this.isActive,
    this.id,
  });

  UserList.fromJson(DocumentSnapshot<Object> json) {
    //print("in list data ${json}");
    print("get name in model ${json['name']}");
    name = json['name'] ?? '';
    lastMessage = json['lastSeen'];
    image = json['image'];
    lastSceen = json['createAt'];
    isActive = json['status'];
    id = json.id;
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    // data['name'] = this.name;
    return data;
  }
}
