import 'dart:async';

import 'package:client/feature_personal_settings/service/ros_ip.service.dart';
import 'package:client/ros/services/ros.service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ScenariosDragtarget extends StatefulWidget {
  const ScenariosDragtarget({super.key});

  @override
  State<ScenariosDragtarget> createState() => _ScenariosDragtargetState();
}

class _ScenariosDragtargetState extends State<ScenariosDragtarget> {
  StreamController<double> controller1 = StreamController<double>.broadcast();
  late Stream stream = controller1.stream;
  bool sound = true;

  RosIp rosIp = RosIp();

  //for testing rosIp.ipVariable
  late ROSService rosService = ROSService(rosIp.ipVariable);
  String topic = "/environment/scene/value";
  String type = "victor_msgs/msg/String";

  Map<int,String> scene = {
    0 : 'Lobby',
    1 : 'Muellablage',
    2 : 'Tiefgarage',
    3 : 'Haupteingang',
    4 : 'Trainingsplatz',
    5 : 'Getraenkeablage',
    6 : 'Bierzelte',
    7 : 'Waldstadion',
    8 : 'Passthrough',
    9 : 'RidingVehicle'
  };

  Future<void> callback(String scenarioVR) async{
    await Future.delayed(const Duration(seconds: 1), (){
      scene.forEach((key, value) {
        if (scenarioVR == value) {
          debugPrint(scenarioVR);
          if (currentIndex != key) {
            print("change");
            setState(() {
              currentIndex = key;
            });
          }
        }
      });
    });
  }


  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    rosService.subscribe("/environment/scene/state", type, (data) => callback(data['ros_text']));
    ColorScheme customColor = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 500,
        height: 200,
        decoration: BoxDecoration(
          color: customColor.primary,
          border: Border.all(color: customColor.secondary),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text("Szenarios / Scenario",
                      style: TextStyle(
                          color: customColor.secondary,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ToggleSwitch(
                minWidth: 40.0,
                minHeight: 30.0,
                fontSize: 12.0,
                initialLabelIndex: currentIndex,
                cornerRadius: 10.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 10,
                icons: const [
                  FontAwesomeIcons.house,
                  FontAwesomeIcons.industry,
                  FontAwesomeIcons.squareParking,
                  FontAwesomeIcons.doorOpen,
                  FontAwesomeIcons.futbol,
                  FontAwesomeIcons.wineBottle,
                  FontAwesomeIcons.beerMugEmpty,
                  FontAwesomeIcons.gopuram,
                  FontAwesomeIcons.vrCardboard,
                  FontAwesomeIcons.car,
                ],
                activeBgColors: const [
                  [Colors.green],
                  [Colors.brown],
                  [Colors.blue],
                  [Colors.deepPurple],
                  [Colors.yellow],
                  [Colors.lightGreen],
                  [Colors.cyan],
                  [Colors.white10],
                  [Colors.deepPurple],
                  [Colors.black38]
                ],
                onToggle: (index) {
                  if (index == 0) {
                    setState(() {
                      rosService.publish(topic, type, {
                        'timestamp': DateTime.now().toString(),
                        'id': 'flutter',
                        'ros_text': 'Lobby'
                      });
                      currentIndex = 0;
                    });
                  } else if (index == 1) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Muellablage'
                    });
                    currentIndex = 1;
                  } else if (index == 2) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Tiefgarage'
                    });
                    currentIndex = 2;
                  } else if (index == 3) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Haupteingang'
                    });
                    currentIndex = 3;
                  } else if (index == 4) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Trainingsplatz'
                    });
                    currentIndex = 4;
                  } else if (index == 5) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Getraenkeablage'
                    });
                    currentIndex = 5;
                  } else if (index == 6) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Bierzelte'
                    });
                    currentIndex = 6;
                  } else if (index == 7) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Waldstadion'
                    });
                    currentIndex = 7;
                  } else if (index == 8) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Passthrough'
                    });
                    currentIndex = 8;
                  } else if (index == 9) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'RidingVehicle'
                    });
                    currentIndex = 9;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void snackBarScenario(String whichScenario) {
    final snackBar = SnackBar(
      content: Text('Switch to Scenario: $whichScenario'),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
