

import 'dart:io';


import 'package:client/feature_personal_settings/service/ros_ip.service.dart';
import 'package:client/ros/services/ros.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';




class DownloadAudioDragtarget extends StatefulWidget {
  const DownloadAudioDragtarget({super.key});

  @override
  State<DownloadAudioDragtarget> createState() => _DownloadAudioDragtargetState();
}

class _DownloadAudioDragtargetState extends State<DownloadAudioDragtarget> {
  FlutterSoundPlayer soundPlayer = FlutterSoundPlayer();

  String downlaodFilePath = "";
  Future<void> downloadFile() async {
    var url = 'http://cfc@192.168.0.90:5000/download'; // Adjust URL accordingly

    var response = await http.post(Uri.parse(url));
    var bytes = response.bodyBytes;
    var dir = await getDownloadsDirectory();
    File file = File('${dir!.path}/audio_file.wav');
    await file.writeAsBytes(bytes);
    downlaodFilePath = file.path;
    if(await file.exists()){
      debugPrint("it exists");
      await soundPlayer.startPlayer(
        fromDataBuffer: bytes, // Specify the correct codec for your audio file
          codec: Codec.pcm16, numChannels: 1, sampleRate: 16000,
          whenFinished: (){
            closeServer();
        }
      );
    }
  }

  Future<void> closeServer() async {
    await http.get(Uri.parse('http://cfc@192.168.0.90:5000/close'));
  }

  Future<void> healthCheckServer() async {
    var url = 'http://cfc@192.168.0.90:5000/health'; // Adjust URL accordingly
    for (int i = 0; i < 10; i++) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          // Server is up and running
          downloadFile();
          break;
        } else {
          // Server is not okay
          debugPrint('Server is not healthy');
        }
      } catch (e) {
        // Error occurred while checking server status
        debugPrint('Error: $e');
      }
      // Wait for some time before the next check
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    super.initState();
    soundPlayer.openPlayer().then((value) {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    soundPlayer.closePlayer();
    super.dispose();
  }

  RosIp rosIp = RosIp();

  //for testing rosIp.ipVariable
  late ROSService rosService = ROSService(rosIp.ipVariable);
  String topicAudio = "/mic_record/value";
  String topicVideo = "/ros_record/value";
  String type = "victor_msgs/msg/String";

  bool recordingAudio = false;
  bool recordingVideo = false;

  @override
  Widget build(BuildContext context) {

    //a bool if it is web or mobile
    ColorScheme customColor = Theme.of(context).colorScheme;
    return Container(
        decoration: BoxDecoration(
          color: customColor.primary,
          border: Border.all(color: customColor.secondary),
        ),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Video"),
                        Stack(
                          children: [
                            !recordingVideo ? IconButton(onPressed: (){
                              rosService.publish(topicVideo, type, {
                                'timestamp': DateTime.now().toString(),
                                'id': 'flutter',
                                'ros_text': 'start'
                              });
                              setState(() {
                                recordingVideo = true;
                              });}, icon: const Icon(FontAwesomeIcons.play, size: 40,))
                                : IconButton(onPressed: (){
                              rosService.publish(topicVideo, type, {
                                'timestamp': DateTime.now().toString(),
                                'id': 'flutter',
                                'ros_text': 'stop'
                              }); setState(() {
                                recordingVideo = false;
                              });},
                                icon: const Icon(FontAwesomeIcons.stop, size: 40,)),
                          ],
                        ),
                        !recordingVideo ? IconButton(onPressed: (){

                          healthCheckServer();
                        }, icon: const Icon(FontAwesomeIcons.solidFileAudio, size: 30,)) : Container(),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Audio"),
                        Stack(
                          children: [
                           !recordingAudio ? IconButton(onPressed: (){
                             rosService.publish(topicAudio, type, {
                               'timestamp': DateTime.now().toString(),
                               'id': 'flutter',
                               'ros_text': 'start'
                             });
                             setState(() {
                               recordingAudio = true;
                             });}, icon: const Icon(FontAwesomeIcons.play, size: 40,))
                            : IconButton(onPressed: (){
                             rosService.publish(topicAudio, type, {
                               'timestamp': DateTime.now().toString(),
                               'id': 'flutter',
                               'ros_text': 'stop'
                             }); setState(() {
                               recordingAudio = false;
                             });},
                               icon: const Icon(FontAwesomeIcons.stop, size: 40,)),
                          ],
                        ),
                        !recordingAudio ? IconButton(onPressed: (){
                          rosService.publish(topicAudio, type, {
                            'timestamp': DateTime.now().toString(),
                            'id': 'flutter',
                            'ros_text': 'download'
                          });
                          healthCheckServer();
                        }, icon: const Icon(FontAwesomeIcons.solidFileAudio, size: 30,)) : Container(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
