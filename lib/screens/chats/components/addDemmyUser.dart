import 'package:chatmodule/firebase/db_method.dart';
import 'package:chatmodule/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class UserAddScreen extends StatefulWidget {
  const UserAddScreen({Key key}) : super(key: key);

  @override
  _UserAddScreenState createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController image = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvide = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login with : ${userProvide.loginUserData.name}",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Name"),
                controller: name,
              ),
              TextButton(
                  onPressed: () {
                    DataBase().addUser({
                      "name": name.text.toLowerCase(),
                      "status": true,
                      "image":
                          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
                      "createAt": DateTime.now().toString(),
                      "lastMessage": '',
                      "lastSeen": ""
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
