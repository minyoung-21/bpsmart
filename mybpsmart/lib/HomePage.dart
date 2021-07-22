import './Auth_Service.dart';
import 'ActionBut.dart';
import 'AddFreezer.dart';
import './SignUpPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ActionBut(),
      body: AddFreezer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await authClass.logout();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => SignUpPage()),
                  (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
