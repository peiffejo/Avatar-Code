
import 'package:client/elements/widgets/audioframe.widget.dart';
import 'package:client/ros/repositories/audio.repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../feature_personal_settings/service/ros_ip.service.dart';

import '../../../ros/services/ros.service.dart';

class RosAudiostreamDragtarget extends StatefulWidget {
  const RosAudiostreamDragtarget({super.key});

  @override
  State<RosAudiostreamDragtarget> createState() => _RosAudiostreamDragtargetState();
}

class _RosAudiostreamDragtargetState extends State<RosAudiostreamDragtarget> {
  RosIp rosIp = RosIp();

  //for testing rosIp.ipVariable
  late ROSService rosService = ROSService(rosIp.ipVariable);
  String topic = "/mic_stream";
  String type = "victor_msgs/Audio";

  @override
  void dispose() {
    rosService.close();
    super.dispose();
  }


  //Here you can design the widget, which can then be seen on the dragtarget

  bool downloadButton = false;

  Map<String, dynamic> data = {
    'msg' : 'stop',
  };

  @override
  Widget build(BuildContext context) {
    ROSAudioStreamHandler audioHandler = ROSAudioStreamHandler(rosService, topic);
    audioHandler.startHandler();
    AudioStreamWidget audioStreamWidget = AudioStreamWidget(audioHandler);

    //a bool if it is web or mobile
    //var widthTile = kIsWeb == true ? 500.0 : 200.0;
    //var heightTile = kIsWeb == true ? 450.0 : 150.0;
    ColorScheme customColor = Theme.of(context).colorScheme;
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: customColor.primary,
          border: Border.all(color: customColor.secondary),
        ),
        child: Stack(
          children: [
            Container(
              child: audioStreamWidget
            ),
            Center(
              child: IconButton(onPressed: (){
                rosService.publish("/mic_stream/stop", 'victor_msgs/msg/String', {'timestamp': DateTime.now().toString(), 'id': 'flutters', 'ros_text': 'stop'});
              }, icon: Icon(FontAwesomeIcons.x)),
            ),
          ],
        )
    );
  }
}
