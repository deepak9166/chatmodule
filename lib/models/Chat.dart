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
  String userCreateAt;
  bool isActive;
  String id;
  String lastSceen;
  UserList({
    this.name,
    this.lastMessage,
    this.image,
    this.userCreateAt,
    this.isActive,
    this.id,
    this.lastSceen,
  });

  UserList.fromJson(DocumentSnapshot<Object> json) {
    //print("in list data ${json}");
    print("get name in model ${json['name']}");
    name = json['name'] ?? '';
    lastMessage = json['lastSeen'];
    image = json['image'];
    userCreateAt = json['createAt'];
    isActive = json['status'];
    lastSceen = json['lastSeen'];
    id = json.id;
  }
  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    // data['name'] = this.name;
    return data;
  }
}
