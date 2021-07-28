import 'package:chatmodule/models/Chat.dart';
import 'package:chatmodule/provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:chatmodule/unitl.dart';
import '../../constants.dart';
import 'components/chatInbox.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvide = Provider.of(context, listen: false);
    return Scaffold(
      appBar: buildAppBar(userProvide, context),
      body: Body(),
    );
  }

  AppBar buildAppBar(UserProvider userProvide, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 2,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          // BackButton(
          //   color: Colors.black,
          // ),
          CircleAvatar(
            backgroundImage: userProvide.selectedUserChat.image.isEmpty
                ? AssetImage("assets/images/user_2.png")
                : NetworkImage(userProvide.selectedUserChat.image),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${userProvide.selectedUserChat.name.capitalize()}",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream:
                    userProvide.getUserData(userProvide.selectedUserChat.id),
                builder: (context, userStatus) {
                  if (userStatus.connectionState == ConnectionState.active) {
                    UserList selectedUser = UserList.fromJson(userStatus.data);
                    print("time ?>>>>> ${selectedUser.lastMessage}");
                    userProvide.tabOnChat(
                        selectedUser, userProvide.seletedChatId);
                    return Text(
                      selectedUser.isActive
                          ? "Online"
                          : "${Jiffy(DateTime.parse(selectedUser.lastMessage)).fromNow()}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  }
                  return Text("Loading...");
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
