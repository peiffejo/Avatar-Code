
import 'dart:async';

import 'package:client/elements/widgets/videostream.widget.dart';
import 'package:client/feature_personal_settings/service/ros_ip.service.dart';
import 'package:client/ros/models/video.model.dart';
import 'package:client/ros/repositories/video.repository.dart';
import 'package:client/ros/services/ros.service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class RosVideostreamDragtarget extends StatefulWidget {
  const RosVideostreamDragtarget({super.key});

  @override
  State<RosVideostreamDragtarget> createState() => _RosVideostreamDragtargetState();
}

class _RosVideostreamDragtargetState extends State<RosVideostreamDragtarget> {
  RosIp rosIp = RosIp();

  //for testing rosIp.ipVariable
  late ROSService rosService = ROSService(rosIp.ipVariable);
  String topic = "/zed_stream";
  String type = "victor_msgs/Video";
  ROSVideoStream stream = ROSVideoStream();

int zwi = 0;
int count = 0;
  Future<void> subscribeHandlerForVideoData(data) async {
    final ROSVideoFrame frame = ROSVideoFrame.fromJson(data);
    ConnectionStatus.isConnected = true;
      if(frame.timestamp.second == zwi){
        count++;
      }else{
        debugPrint("Frames: $count");
        zwi = 0;
        count = 0;
      }
    zwi = frame.timestamp.second;
    stream.addData(frame);
  }

  @override
  void dispose() {
    rosService.close();
    super.dispose();
  }

  bool isVisible = false;
  //Here you can design the widget, which can then be seen on the dragtarget
  @override
  Widget build(BuildContext context) {
    rosService.subscribe(topic, type, subscribeHandlerForVideoData);
    VideoStreamWidget vsw = VideoStreamWidget(stream, rosService, false);

    //a bool if it is web or mobile
    //var widthTile = kIsWeb == true ? 500.0 : 300.0;
    //var heightTile = kIsWeb == true ? 450.0 : 200.0;
    ColorScheme customColor = Theme.of(context).colorScheme;
    return Container(
        //width: widthTile,
        //height: heightTile,
        decoration: BoxDecoration(
          color: customColor.secondary,
          border: Border.all(color: customColor.secondary),
        ),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Video-Stream", style: TextStyle(color: customColor.background)),
                  ),
                  IconButton(
                    onPressed: () {showOverlay(context);}, icon: Icon(FontAwesomeIcons.expand, color: Theme.of(context).colorScheme.background,),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                decoration: const BoxDecoration(color: Colors.black54),
                child: vsw,
              ),
            ],
          ),
        ),
    );
  }


  void showOverlay(BuildContext context) {
    VideoStreamWidget vsw = VideoStreamWidget(stream, rosService, true);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        child: Container(
            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color.fromARGB(100, 200, 200, 200),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20,30,20,10),
                        child: Text("Ros-Video-Stream", style: TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                      GestureDetector(
                        onTap: (){
                          _removeOverlay(overlayEntry!);
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0,30,20,10),
                          child: Align(
                              alignment: Alignment.bottomRight,child: Icon(FontAwesomeIcons.x)),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, MediaQuery.of(context).size.height/4, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: Colors.black54),
                    child: vsw,
                  ),
                ),
              ],
            )
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after some time (for example, 2 seconds)


  }

  void _removeOverlay(OverlayEntry overlayEntry) {
    overlayEntry.remove();
  }
}
