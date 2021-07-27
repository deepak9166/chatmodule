import 'package:cloud_firestore/cloud_firestore.dart';

class DataBase {
  checkAlreadyCategory(String categoryName) async {
    return await FirebaseFirestore.instance
        .collection("category")
        .where('name', isEqualTo: categoryName.toLowerCase())
        .get();
  }

  uploadUserData(String categoryName) async {
    await FirebaseFirestore.instance.collection("category").add({
      'name': categoryName.toLowerCase(),
    });
  }

  videoData() async {
    return await FirebaseFirestore.instance
        .collection('videoData')
        .orderBy('createAt', descending: true)
        .get();
  }

  Future addStateData(cvData) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection("state")
        .add(cvData)
        .catchError((e) {
      //print("errror $e");
    });
    //print("id***");
    //print(docRef.id);

    return docRef.id;
  }

  Future addUser(userBody) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection("users")
        .add(userBody)
        .catchError((e) {
      //print("errror $e");
    });
    // //print("id***");
    // //print(docRef.id);

    return docRef.id;
  }

  Future<void> addItems(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("videoData")
        .doc(chatRoomId)
        .collection("item")
        .add(chatMessageData)
        .then((result) {
      //print("add message error");
    }).catchError((onError) {
      //print("onError");
    });
  }

  userListData(String videoId) async {
    return await FirebaseFirestore.instance
        .collection('state')
        .doc(videoId)
        .collection("item")
        .orderBy('createAt', descending: true)
        .get();
  }

  Future userList() async {
    return await FirebaseFirestore.instance
        .collection('users')
        // .orderBy('createAt', descending: true)
        .get();
  }

  Stream<QuerySnapshot> getUserChat(String chatId) {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatId)
        .collection(chatId)
        // .where('chatWith', isEqualTo: data['userId'])
        .snapshots();
  }

  String makeChatId(myID, selectedUserID) {
    String chatID;
    if (myID.hashCode > selectedUserID.hashCode) {
      chatID = '$selectedUserID-$myID';
    } else {
      chatID = '$myID-$selectedUserID';
    }
    return chatID;
  }

  Future sendMessageToChatRoom(
      chatID, myID, selectedUserID, content, messageType) async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatID)
        .collection(chatID)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'idFrom': myID,
      'idTo': selectedUserID,
      'createAt': DateTime.now().toString(),
      'content': content,
      'type': messageType,
    });
  }

  Future updateChatRequestField(String documentID, String lastMessage, chatID,
      myID, selectedUserID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(documentID)
        .collection('chatlist')
        .doc(chatID)
        .set({
      'chatID': chatID,
      'chatWith': documentID == myID ? selectedUserID : myID,
      'lastChat': lastMessage,
      'createAt': DateTime.now().toString()
    });
  }

  Future addFiles(cvData) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection("chatfiles")
        .add(cvData)
        .catchError((e) {});
    print("id***");
    print(docRef.id);
    return docRef.id;
  }
}

int countChatListUsers(myID, snapshot) {
  int resultInt = snapshot.data.documents.length;
  for (var data in snapshot.data.documents) {
    if (data['userId'] == myID) {
      resultInt--;
    }
  }
  return resultInt;
}
