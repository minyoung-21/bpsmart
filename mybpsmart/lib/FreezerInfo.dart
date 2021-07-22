import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './ActionBut.dart';

class FreezerInfo extends StatefulWidget {
  late final String freezertitle;
  FreezerInfo({Key? key, required this.freezertitle})
      : super(key: key);
  @override
  _FreezerInfoState createState() =>
      _FreezerInfoState(this.freezertitle);
}

class _FreezerInfoState extends State<FreezerInfo> {
  late final String retrievedName;

  _FreezerInfoState(this.retrievedName);
  void printed() {
    _freezerref.child(uid).once().then((DataSnapshot data) {
      setState(() {
        retrievedName = data.key;
      });
    });
  }

  final uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference db = FirebaseDatabase.instance.reference();
  late DatabaseReference _freezerref;
  late DataSnapshot data;
  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase();
    _freezerref = db.reference().child(uid);
  }

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: ActionBut(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(this.retrievedName),
        ),
        body: Center(
          child: Transform.scale(
            scale: 2.0,
            child: CupertinoSwitch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  _freezerref
                      .child(retrievedName)
                      .set({'bpdata': retrievedName, 'freezerbool': isSwitched}).asStream();
                });
              },
              activeColor: Colors.green,
            ),
          ),
        ));
  }
}
