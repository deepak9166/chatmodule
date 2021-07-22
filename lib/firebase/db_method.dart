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
      print("errror $e");
    });
    print("id***");
    print(docRef.id);

    return docRef.id;
  }

  Future<void> addItems(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("videoData")
        .doc(chatRoomId)
        .collection("item")
        .add(chatMessageData)
        .then((result) {
      print("add message error");
    }).catchError((onError) {
      print("onError");
    });
  }

  videoDataItemData(String videoId) async {
    return await FirebaseFirestore.instance
        .collection('state')
        .doc(videoId)
        .collection("item")
        .orderBy('createAt', descending: true)
        .get();
  }

  stateList() async {
    return await FirebaseFirestore.instance
        .collection('state')
        .orderBy('createAt', descending: true)
        .get();
  }
}
