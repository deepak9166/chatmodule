import 'package:chatmodule/firebase/db_method.dart';
import 'package:chatmodule/models/ChatMessage.dart';
import 'package:chatmodule/provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatelessWidget {
  getMessageType(String type) {
    switch (type) {
      case "text":
        return ChatMessageType.text;
        break;
      case "image":
        return ChatMessageType.image;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvide = Provider.of(context, listen: false);
    return Column(
      children: [
        Expanded(
          child: Container(
              child: StreamBuilder<QuerySnapshot>(
            stream: DataBase().getUserChat(userProvide.seletedChatId),
            builder: (context, userChatSnapshot) {
              if (userChatSnapshot.connectionState == ConnectionState.active) {
                return ListView.builder(
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  itemCount: userChatSnapshot.data.docs.length,
                  itemBuilder: (context, indexChat) {
                    int index =
                        (userChatSnapshot.data.docs.length - 1) - indexChat;
                    var data = ChatMessage(
                        text: "${userChatSnapshot.data.docs[index]['content']}",
                        messageType: getMessageType(
                            userChatSnapshot.data.docs[index]['type']),
                        messageStatus: MessageStatus.viewed,
                        isSender: userChatSnapshot.data.docs[index]['idFrom'] ==
                            userProvide.loginUserData.id,
                        isReceverActive: true,
                        messageTime: userChatSnapshot.data.docs[index]
                            ['createAt']);
                    return Message(message: data);
                  },
                );
              }
              return Container();
            },
          )),
        ),
        ChatInputField(),
      ],
    );
  }
}
