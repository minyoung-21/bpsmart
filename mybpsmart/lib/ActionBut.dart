import 'package:flutter/material.dart';
import './HomePage.dart';
import 'Clear.dart';
import 'FreezerList.dart';

class ActionBut extends StatelessWidget {
  const ActionBut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[ Column(
          children: [
            ListTile(
              title: Text(''),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => FreezerList()),
                    (route) => false);
              },
            ),
            ListTile(
              title: Text('Backpack List'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => FreezerList()),
                    (route) => false);
              },
            ),
            ListTile(
              title: Text('Clear List'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => ClearList()),
                    (route) => false);
              },
            ),
            ListTile(
              title: Text('Add Backpack'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => HomePage()),
                    (route) => false);
              },
            ),
          ],
        )
      ],
    ));
  }
}
