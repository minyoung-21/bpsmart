// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';
import 'ActionBut.dart';

class ClearList extends StatefulWidget {
  late final FirebaseApp app;
  @override
  _ClearListState createState() => _ClearListState();
}

class _ClearListState extends State<ClearList> {
  final textcontroller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  void addData(String useruid, String data) {
    databaseRef.child(useruid).push().child('bpdata').set(data).asStream();
  }

  late DatabaseReference _bpref;
  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase();
    _bpref = databaseRef.reference().child(uid);
  }

  void inputData(String data) {
    addData(uid, data);
  }

  final bpname = 'FreezerTitle';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: ActionBut(),
        appBar: AppBar(
          title: Text('Freezer List'),
        ),
        body: SingleChildScrollView(
            child: Column(
                children:[new FirebaseAnimatedList(
          shrinkWrap: true,
          query: _bpref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            return new Card(
              color: Colors.blue[50],
              child: new ListTile(
                trailing: Icon(Icons.delete),
                onTap: () => _bpref.child(snapshot.key).remove(),
                title: new Text(snapshot.value['bpdata']),
              ),
            );
          },
        )])));
  }
}
