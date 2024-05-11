
import 'package:client/feature_personal_settings/service/ros_ip.service.dart';
import 'package:client/ros/services/ros.service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DummyDragtarget extends StatefulWidget {
  const DummyDragtarget({super.key});

  @override
  State<DummyDragtarget> createState() => _DummyDragtargetState();
}

class _DummyDragtargetState extends State<DummyDragtarget> {
  RosIp rosIp = RosIp();
  late ROSService rosService = ROSService(rosIp.ipVariable);
  String topic = "/environment/dummy/value";
  String type = "victor_msgs/msg/Bool";
  //Here you can design the widget, which can then be seen on the dragtarget

  Future<void> callback(bool bo) async{}

  bool dummy = false;

  @override
  void dispose() {
    rosService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rosService.subscribe("/environment/dummy/state", type, (data) => callback(data['ros_bool']));
    //a bool if it is web or mobile
    ColorScheme customColor = Theme.of(context).colorScheme;
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: customColor.primary,
          border: Border.all(color: customColor.secondary),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           dummy ? const Text("Dummy lebt") : const Text("Dummy tot"),
           const SizedBox(height: 10,),
            IconButton(onPressed: (){
              !dummy;
              rosService.publish(topic, type, {
                'timestamp': DateTime.now().toString(),
                'id': 'flutter',
                'ros_bool': true,
              });
            }, icon: const Icon(FontAwesomeIcons.personFalling, size: 50,)),
          ],
        )
    );
  }
}
