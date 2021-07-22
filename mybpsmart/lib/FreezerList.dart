// ignore: unused_import
import 'package:bluetooth_enable/bluetooth_enable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import './ActionBut.dart';
import './FreezerInfo.dart';

class FreezerList extends StatefulWidget {
  late final FirebaseApp app;
  @override
  _FreezerListState createState() => _FreezerListState();
}

class _FreezerListState extends State<FreezerList> {
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

  Future<void> enableBT(y) async {
    BluetoothEnable.enableBluetooth.then((value) {
      if (value == "false") {
        return FreezerList();
      } else if (value == "true") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => FreezerInfo(
                      freezertitle: y,
                    )),
            (route) => false);
      }
    });
  }

  final freezername = 'FreezerTitle';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: ActionBut(),
        appBar: AppBar(
          title: Text('Freezer List'),
        ),
        body: SingleChildScrollView(
            child: Column(
                children:[ new FirebaseAnimatedList(
          shrinkWrap: true,
          query: _freezerref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            print(snapshot.value["bpdata"]);
            return new Card(
              color: Colors.blue[50],
              child: ListTile(
                title: new Text(snapshot.value['bpdata']),
                onTap: () {
                  enableBT(snapshot.value['bpdata']);
                },
              ),
            );
          },
        )])));
  }
}
