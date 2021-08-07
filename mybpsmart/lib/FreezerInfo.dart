// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mybpsmart/finddevice.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
// import './ActionBut.dart';
// import 'package:pedometer/pedometer.dart';

// class FreezerInfo extends StatefulWidget {
//   late final String freezertitle;
//   FreezerInfo({Key? key, required this.freezertitle}) : super(key: key);
//   @override
//   _FreezerInfoState createState() => _FreezerInfoState(this.freezertitle);
// }

// class _FreezerInfoState extends State<FreezerInfo> {
//   late final String retrievedName;
//   late Stream<StepCount> _stepCountStream;
//   late Stream<PedestrianStatus> _pedestrianStatusStream;
//   String _status = '?', _steps = '?';

//   _FreezerInfoState(this.retrievedName);
//   void printed() {
//     _freezerref.child(uid).once().then((DataSnapshot data) {
//       setState(() {
//         retrievedName = data.key;
//       });
//     });
//   }

//   final uid = FirebaseAuth.instance.currentUser!.uid;
//   DatabaseReference db = FirebaseDatabase.instance.reference();
//   late DatabaseReference _freezerref;
//   late DataSnapshot data;
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     final FirebaseDatabase database = FirebaseDatabase();
//     _freezerref = db.reference().child(uid);
//   }

//   @override
//   void onStepCount(StepCount event) {
//     setState(() {
//       _steps = event.steps.toString();
//     });
//   }

//   void onPedestrianStatusChanged(PedestrianStatus event) {
//     setState(() {
//       _status = event.status;
//     });
//   }

//   void onPedestrianStatusError(error) {
//     setState(() {
//       _status = 'Pedestrian Status not available';
//     });
//   }

//   void onStepCountError(error) {
//     print('onStepCountError: $error');
//     setState(() {
//       _steps = 'Step Count not available';
//     });
//   }

//   void initPlatformState() {
//     _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
//     _pedestrianStatusStream
//         .listen(onPedestrianStatusChanged)
//         .onError(onPedestrianStatusError);

//     _stepCountStream = Pedometer.stepCountStream;
//     _stepCountStream.listen(onStepCount).onError(onStepCountError);

//     if (!mounted) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: ActionBut(),
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(this.retrievedName),
//         ),
//         body: Container(
//           child: Column(children: [
//             SizedBox(
//               height: 15,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 SfRadialGauge(
//         title: GaugeTitle(
//             text: 'Backpack meter',
//             textStyle:
//                 const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
//         axes: <RadialAxis>[
//           RadialAxis(minimum: 0, maximum: 40, ranges: <GaugeRange>[
//             GaugeRange(
//                 startValue: 0,
//                 endValue: 40,
//                 color: Colors.blue,
//                 startWidth: 10,
//                 endWidth: 10),
//             // GaugeRange(
//             //     startValue: 50,
//             //     endValue: 100,
//             //     color: Colors.orange,
//             //     startWidth: 10,
//             //     endWidth: 10),
//             // GaugeRange(
//             //     startValue: 100,
//             //     endValue: 150,
//             //     color: Colors.red,
//             //     startWidth: 10,
//             //     endWidth: 10)
//           ], pointers: <GaugePointer>[
//             NeedlePointer(value: 40)
//           ], annotations: <GaugeAnnotation>[
//             GaugeAnnotation(
//                 widget: Container(
//                     child: const Text('90.0',
//                         style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold))),
//                 angle: 90,
//                 positionFactor: 0.5)
//           ])
//         ])
//                 // new CircularPercentIndicator(
//                 //   radius: 100.0,
//                 //   lineWidth: 5.0,
//                 //   percent: 1.0,
//                 //   center: new Text("100%"),
//                 //   progressColor: Colors.green,
//                 // ),
//               ],
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Column(
//                     children: [Text("steps taken:"), Text(_steps)],
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         _status, //2
//                         style: _status == 'walking' || _status == 'stopped'
//                             ? TextStyle(fontSize: 10)
//                             : TextStyle(fontSize: 10, color: Colors.red),
//                       ),
//                       Icon(
//                         _status == 'walking'
//                             ? Icons.directions_walk
//                             : _status == 'stopped'
//                                 ? Icons.accessibility_new //3
//                                 : Icons.error,
//                        ),
//                       // RaisedButton(
//                       //   child: Text('Trigger your data'),
//                       //   onPressed: () {
//                       //   Navigator.pushAndRemoveUntil(
//                       //   context,
//                       //   MaterialPageRoute(builder: (builder) => FlutterBlueApp()),
//                       //   (route) => false);
//                       // })
//                     ],
//                   )
//                 ]),
//           ]),
//         ));
//   }
// }
