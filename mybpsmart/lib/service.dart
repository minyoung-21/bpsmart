import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_blue/flutter_blue.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({Key? key, required this.device}) : super(key: key);

  final BluetoothDevice device;

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  // final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  // final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late bool isReady;
  late Stream<List<int>> stream;
  List<double> traceDust = [];
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
    initPlatformState();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    new Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    // List<BluetoothService> services = await widget.device.discoverServices();
    // services.forEach((service) {
    //   if (service.uuid.toString() == SERVICE_UUID) {
    //     service.characteristics.forEach((characteristic) {
    //       if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
    //         characteristic.setNotifyValue(!characteristic.isNotifying);
    //         stream = characteristic.value;
    //         setState(() {
    //           isReady = true;
    //         });
    //       }
    //     });
    //   }
    // });

    if (!isReady) {
      _Pop();
    }
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Realtime data'),
        ),
        body: Container(
            child: Column(children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SfRadialGauge(
                  title: GaugeTitle(
                      text: 'Backpack meter',
                      textStyle: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  axes: <RadialAxis>[
                    RadialAxis(minimum: 0, maximum: 40, ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 40,
                          color: Colors.blue,
                          startWidth: 10,
                          endWidth: 10),
                      // GaugeRange(
                      //     startValue: 50,
                      //     endValue: 100,
                      //     color: Colors.orange,
                      //     startWidth: 10,
                      //     endWidth: 10),
                      // GaugeRange(
                      //     startValue: 100,
                      //     endValue: 150,
                      //     color: Colors.red,
                      //     startWidth: 10,
                      //     endWidth: 10)
                    ], pointers: <GaugePointer>[
                      NeedlePointer(
                          value: 34 //traceDust[traceDust.length].toDouble()
                          )
                    ], annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                            child: Container(
                                child: !isReady
                                    ? Center(
                                        child: Text(
                                          "Waiting...",
                                          style: TextStyle(
                                              fontSize: 24, color: Colors.red),
                                        ),
                                      )
                                    : Container(
                                        child: StreamBuilder<List<int>>(
                                          stream: stream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<int>>
                                                  snapshot) {
                                            if (snapshot.hasError)
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            if (snapshot.connectionState ==
                                                ConnectionState.active) {
                                              var currentValue =
                                                  _dataParser(snapshot.data!);
                                              traceDust.add(double.tryParse(
                                                      currentValue) ??
                                                  0);
                                              return Center(
                                                  child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                              'Current value from Sensor',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          Text(
                                                              '$currentValue kg',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 24))
                                                        ]),
                                                  ),
                                                ],
                                              ));
                                            } else {
                                              return Text('Check the stream');
                                            }
                                          },
                                        ),
                                      )),
                          ),
                          angle: 90,
                          positionFactor: 0.5)
                    ])
                  ]),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [Text("steps taken:"), Text(_steps)],
              ),
              Column(
                children: [
                  Text(
                    _status, //2
                    style: _status == 'walking' || _status == 'stopped'
                        ? TextStyle(fontSize: 10)
                        : TextStyle(fontSize: 10, color: Colors.red),
                  ),
                  Icon(
                    _status == 'walking'
                        ? Icons.directions_walk
                        : _status == 'stopped'
                            ? Icons.accessibility_new //3
                            : Icons.error,
                  ),
                ],
              )
            ],
          ),
        ])));
  }
}
