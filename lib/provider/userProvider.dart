import 'package:chatmodule/firebase/db_method.dart';
import 'package:chatmodule/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  UserList loginUserData;
  String selectedId;
  String seletedChatId;
  TextEditingController message = TextEditingController();
  String messageString = '';
  UserList selectedUserChat;

  Stream<DocumentSnapshot> getUserData(String uId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        // .collection('chatlist')
        // .where('chatWith', isEqualTo: data['userId'])
        .snapshots();
  }

  setUserData(UserList data) {
    loginUserData = data;
    print("data added ${loginUserData.name}");

    notifyListeners();
  }

  updateStatus(bool status) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginUserData.id)
        .update({'lastSeen': DateTime.now().toString(), "status": status});
  }

  tabOnChat(UserList selectUser, String chatId) {
    selectedId = selectUser.id;
    seletedChatId = chatId;
    selectedUserChat = selectUser;
    notifyListeners();
  }

  setMessage(String value) {
    messageString = value;
    notifyListeners();
  }

  sendMessage(String messageType) {
    DataBase().sendMessageToChatRoom(seletedChatId, loginUserData.id,
        selectedId, messageString, messageType);

    DataBase().updateChatRequestField(
        selectedId, messageString, seletedChatId, loginUserData.id, selectedId);

    DataBase().updateChatRequestField(loginUserData.id, messageString,
        seletedChatId, selectedId, loginUserData.id);

    message.clear();
    messageString = "";
    notifyListeners();
  }
}
