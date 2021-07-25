import 'package:chatmodule/models/Chat.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'package:jiffy/jiffy.dart';

class ChatCard extends StatelessWidget {
  const ChatCard(
      {Key key,
      @required this.press,
      this.isActive,
      this.lastMessage,
      this.lastSeen,
      this.name,
      this.userImage})
      : super(key: key);

  final String name;
  final String lastMessage;
  final String lastSeen;
  final bool isActive;
  final String userImage;

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    //print(chat.time);
    return InkWell(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(15, 20),
              ),
            ]),
        margin: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // BoxShape.circle or BoxShape.retangle
                        color: Colors.white,
                        // borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(10, 2),
                          ),
                        ]),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: userImage == null
                          ? AssetImage("assets/images/user.png")
                          : NetworkImage(userImage),
                    ),
                  ),
                  if (isActive)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 3),
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Opacity(
                opacity: 0.64,
                child: Text(Jiffy(DateTime.parse(lastSeen)).jm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
