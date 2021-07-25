import 'package:chatmodule/lifeCycle.dart';
import 'package:chatmodule/models/Chat.dart';
import 'package:chatmodule/provider/userProvider.dart';
import 'package:chatmodule/screens/chats/chats_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    bool isActive = false;
    UserProvider userProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(suspendingCallBack: () async {
      print("stop >>>>>>>>>>>>>>>>>>>>>>> ");
      isActive = true;
      // _log.finest('resume...');
      if (isActive) {
        isActive = false;
        print("offline");
        userProvider.updateStatus(false);
      }
    }, resumeCallBack: () async {
      print("resume >>>>>>>>>>>>>>>>>>>>>>> ");
      if (!isActive) {
        isActive = true;
        userProvider.updateStatus(true);
        print("online");
      }
      // isActive = false;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context, listen: false);
    userProvider.getUserData("6tjomYmeD2BNW3pmXtwr").listen((event) {
      UserList loginUserData = UserList.fromJson(event);
      userProvider.setUserData(loginUserData);
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: TextStyle(color: Colors.blue, fontSize: 24),
              ),
              FittedBox(
                child: TextButton(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatsScreen(),
                          ),
                        ),
                    child: Row(
                      children: [
                        Text(
                          "Skip",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .color
                                  .withOpacity(0.8)),
                        ),
                        SizedBox(width: kDefaultPadding / 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(0.8),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
