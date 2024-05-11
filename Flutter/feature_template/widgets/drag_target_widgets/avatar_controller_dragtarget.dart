
import 'package:client/feature_personal_settings/service/ros_ip.service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../ros/services/ros.service.dart';

class AvatarControllerDragtarget extends StatefulWidget {
  const AvatarControllerDragtarget({super.key});

  @override
  State<AvatarControllerDragtarget> createState() => _AvatarControllerDragtargetState();
}

class _AvatarControllerDragtargetState extends State<AvatarControllerDragtarget> {
  RosIp rosIp = RosIp();

  //for testing rosIp.ipVariable
  late ROSService rosService = ROSService(rosIp.ipVariable);
  String topic = "/avatar_controller";
  String type = "victor_msgs/msg/String";


  //Here you can design the widget, which can then be seen on the dragtarget
  @override
  Widget build(BuildContext context) {
    ColorScheme customColor = Theme.of(context).colorScheme;
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: customColor.primary,
          border: Border.all(color: customColor.secondary),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Avatar-Controller", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                power("Matrix", (){
                  debugPrint("Matrix");
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'start_matrix'
                  });
                }, (){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'stop_matrix'
                  });
                }),
                power("Mic-Aufnahme", (){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'start_mic_record'
                  });
                },(){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'stop_mic_record'
                  });
                }),
                power("Zed-Aufnahme", (){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'start_zed_record'
                  });
                },(){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'stop_zed_record'
                  });
                }),
                power("Mic-Stream", (){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'start_mic_stream'
                  });
                },(){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'stop_mic_stream'
                  });
                }),
                power("Zed-Stream", (){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'start_zed_stream'
                  });
                },(){
                  rosService.publish(topic, type, {
                    'timestamp': DateTime.now().toString(),
                    'id': 'flutter',
                    'ros_text': 'stop_zed_stream'
                  });
                }),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
    );
  }

   power(String title, Function on, Function off){
    return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         const SizedBox(height: 5,),
         Text(title),
         const SizedBox(height: 2,),
         ToggleSwitch(
           minWidth: 30.0,
           minHeight: 20.0,
           borderColor: [Colors.black],
           borderWidth: 0.5,
           initialLabelIndex: 0,
           cornerRadius: 100.0,
           activeFgColor: Colors.white,
           inactiveBgColor: Colors.grey,
           inactiveFgColor: Colors.white,
           totalSwitches: 2,
           icons: const [
             FontAwesomeIcons.slash,
             FontAwesomeIcons.powerOff,
           ],
           iconSize: 20.0,
           activeBgColors: const [[Colors.black45, Colors.black26], [Colors.green, Colors.lightGreen]],
           animate: true, // with just animate set to true, default curve = Curves.easeIn
           curve: Curves.bounceInOut, // animate must be set to true when using custom curve
           onToggle: (index) {
             if(index == 0){
               off();
             }
             if(index == 1){
               on();
             }
           },
         ),
       ],
     );
   }
}
