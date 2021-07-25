import 'dart:io';

import 'package:chatmodule/models/ChatMessage.dart';
import 'package:chatmodule/provider/userProvider.dart';
import 'package:chatmodule/unitl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    Key key,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  var _playerSubscription;

  start() async {
    // String path = await flutterSound.startPlayer(null);
    // _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
    //   if (e != null) {
    //     DateTime date =
    //         new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
    //     String txt = DateFormat('mm:ss:SS', 'en_US').format(date);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userData = Provider.of(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(width: kDefaultPadding),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withOpacity(0.64),
                      ),
                    ),
                    SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                        controller: userData.message,
                        onChanged: (value) {
                          userData.setMessage(value);
                        },
                      ),
                    ),
                    Consumer<UserProvider>(
                      builder: (context, userProvider2, child) {
                        return userProvider2.messageString.isEmpty
                            ? Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      uploadImage(context, false);
                                    },
                                    child: Icon(
                                      Icons.attach_file,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color
                                          .withOpacity(0.64),
                                    ),
                                  ),
                                  SizedBox(width: kDefaultPadding / 4),
                                  InkWell(
                                    onTap: () {
                                      uploadImage(context, true);
                                    },
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color
                                          .withOpacity(0.64),
                                    ),
                                  ),
                                ],
                              )
                            : InkWell(
                                onTap: () {
                                  userProvider2.sendMessage(
                                    "text",
                                  );
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color
                                      .withOpacity(0.64),
                                ),
                              );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadImage(BuildContext context, bool isCamara) {
    UserProvider userData = Provider.of(context, listen: false);
    getImagePicker(isCamra: isCamara).then((result) async {
      print(result);
      File file = File(result.path);
      final _storage = firebase_storage.FirebaseStorage.instance;
      String _fileName = result.path.split("/").last;
      await _storage
          .ref()
          .child(_fileName)
          .putFile(file)
          .whenComplete(() async {
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(_fileName);
        await ref.getDownloadURL().then((fileURL) async {
          await ref.getDownloadURL().then((imageURL) {
            userData.setMessage(imageURL);
            userData.sendMessage("image");
          });
        });
      });
    });
  }
}
