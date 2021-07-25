import 'package:chatmodule/components/filled_outline_button.dart';
import 'package:chatmodule/firebase/db_method.dart';
import 'package:chatmodule/models/Chat.dart';
import 'package:chatmodule/provider/userProvider.dart';
import 'package:chatmodule/screens/messages/message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import 'chat_card.dart';
import 'package:chatmodule/unitl.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isSearch = false;
  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> getSuggestion(String suggestion) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: suggestion)
        .where('name', isLessThan: suggestion + 'z')
        .snapshots();
  }

  ChatUser searchUser;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvide = Provider.of(context, listen: false);
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(
                vertical: kPagingTouchSlop, horizontal: kPagingTouchSlop),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(2, 5),
                  ),
                ]),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search ",
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    )),
                cursorColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    isSearch = value.isNotEmpty;
                    getSuggestion(value).listen((value) {
                      searchUser = ChatUser.fromJson(value);
                      print("check lenght >>>> ${value.docs.length}");
                    });
                  });
                },
              ),
            )),
        isSearch && searchUser.dataList.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: searchUser.dataList.length,
                  itemBuilder: (context, index) {
                    return searchUser.dataList[index].id ==
                            userProvide.loginUserData.id
                        ? SizedBox()
                        : ChatCard(
                            // chat: searchUser.dataList[index],

                            isActive: false,
                            lastMessage: '',
                            lastSeen: searchUser.dataList[index].lastSceen,
                            name: searchUser.dataList[index].name,
                            userImage: searchUser.dataList[index].image,
                            press: () {
                              var chatId = DataBase().makeChatId(
                                  userProvide.loginUserData.id,
                                  searchUser.dataList[index].id);

                              // print(chatId);
                              userProvide.tabOnChat(
                                  searchUser.dataList[index], chatId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessagesScreen(),
                                ),
                              );
                            });
                  },
                ),
              )
            : Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userProvide.loginUserData.id)
                        .collection('chatlist')
                        .orderBy('createAt', descending: true)
                        .snapshots(),
                    builder: (context, usersListSnapshot) {
                      if (usersListSnapshot.connectionState ==
                          ConnectionState.active) {
                        // ChatUser userData =
                        //     ChatUser.fromJson(usersListSnapshot.data);
                        if (usersListSnapshot.hasData) {
                          return ListView.builder(
                            itemCount: usersListSnapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder<DocumentSnapshot>(
                                  stream: userProvide.getUserData(
                                      usersListSnapshot.data.docs[index]
                                          ['chatWith']),
                                  builder: (context, userDetail) {
                                    if (userDetail.connectionState ==
                                        ConnectionState.active) {
                                      UserList uData =
                                          UserList.fromJson(userDetail.data);
                                      QueryDocumentSnapshot<Object>
                                          chatListData =
                                          usersListSnapshot.data.docs[index];
                                      return ChatCard(
                                          isActive: false,
                                          lastMessage: chatListData['lastChat'],
                                          lastSeen: chatListData['createAt'],
                                          name: "${uData.name.capitalize()}",
                                          userImage: "${uData.image}",
                                          press: () {
                                            var chatId = DataBase().makeChatId(
                                                userProvide.loginUserData.id,
                                                uData.id);

                                            userProvide.tabOnChat(
                                                uData, chatId);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MessagesScreen(),
                                              ),
                                            );
                                          });
                                    }

                                    return Container();
                                  });
                            },
                          );
                        } else if (usersListSnapshot.hasError) {
                          return Text("Somthing Error");
                        }
                      }

                      return Text("No data");
                    }),
              )
      ],
    );
  }
}

class Firestore {}
