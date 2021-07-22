// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'FreezerList.dart';

class AddFreezer extends StatefulWidget {
  late final FirebaseApp app;
  @override
  _AddFreezerState createState() => _AddFreezerState();
}

class _AddFreezerState extends State<AddFreezer> {
  final textcontroller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  void addData(String useruid, String data) {
    databaseRef.child(useruid).child(data).set({'bpdata': data}).asStream();
  }

  late DatabaseReference _freezerref;
  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase();
    _freezerref = databaseRef.reference().child(uid);
  }

  void inputData(String data) {
    addData(uid, data);
  }

  final freezername = 'freezerTitle';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: textcontroller,
            ),
          ),
          Center(
              child: RaisedButton(
                  child: Text("Save to Database"),
                  onPressed: () {
                    inputData(textcontroller.text);
                    textcontroller.clear();
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => FreezerList()),
                        (route) => false);
                  })),
        ],
      ),
    ));
  }
}
