
import 'package:client/feature_personal_settings/service/ros_ip.service.dart';
import 'package:client/ros/services/ros.service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MatrixControllerDragtarget extends StatefulWidget {
  const MatrixControllerDragtarget({super.key});

  @override
  State<MatrixControllerDragtarget> createState() => _MatrixControllerDragtargetState();
}

class _MatrixControllerDragtargetState extends State<MatrixControllerDragtarget> {

  RosIp rosIp = RosIp();

  //for testing rosIp.ipVariable
  late ROSService rosService = ROSService(rosIp.ipVariable);
  String topic = "/avatar_matrix";
  String type = "victor_msgs/msg/String";

  //Here you can design the widget, which can then be seen on the dragtarget
  @override
  Widget build(BuildContext context) {
    //a bool if it is web or mobile
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
                  child: Text("Matrix",
                      style: TextStyle(
                          color: customColor.secondary,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ToggleSwitch(
                minWidth: 70.0,
                minHeight: 100.0,
                fontSize: 12.0,
                initialLabelIndex: 0,
                cornerRadius: 10.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 5,
                labels: ['Hi', 'Stop', 'sleep', 'D', 'D'],
                icons: const [
                  FontAwesomeIcons.speakap,
                  FontAwesomeIcons.x,
                  FontAwesomeIcons.bed,
                  FontAwesomeIcons.doorOpen,
                  FontAwesomeIcons.futbol,
                ],
                activeBgColors: const [
                  [Colors.green],
                  [Colors.brown],
                  [Colors.blue],
                  [Colors.deepPurple],
                  [Colors.yellow],
                ],
                onToggle: (index) {
                  if (index == 0) {
                    setState(() {
                      rosService.publish(topic, type, {
                        'timestamp': DateTime.now().toString(),
                        'id': 'flutter',
                        'ros_text': 'hi'
                      });
                    });
                  } else if (index == 1) {
                     /*rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'stop'
                    });*/
                  } else if (index == 2) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'sleep'
                    });

                  } else if (index == 3) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Haupteingang'
                    });
                  } else if (index == 4) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Trainingsplatz'
                    });

                  } else if (index == 5) {
                    rosService.publish(topic, type, {
                      'timestamp': DateTime.now().toString(),
                      'id': 'flutter',
                      'ros_text': 'Getraenkeablage'
                    });

                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
