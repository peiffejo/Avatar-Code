import 'dart:async';

import 'package:client/ros/models/video.model.dart';
import 'package:client/ros/repositories/video.repository.dart';
import 'package:client/ros/services/ros.service.dart';
import 'package:flutter/material.dart';

class ConnectionStatus{
  static bool isConnected = true;
  void updateConnection(bool value) async {
      isConnected = value;
  }
}

class VideoStreamWidget extends StatefulWidget {
  final ROSVideoStream stream;
  final ROSService rosService;
  final bool overlay;
   const VideoStreamWidget(this.stream, this.rosService,  this.overlay, {super.key});


  @override
  State<VideoStreamWidget> createState() => _VideoStreamWidgetState();
}

class TimeManagment{
  int frameTime = 0;
}

class _VideoStreamWidgetState extends State<VideoStreamWidget> {



  @override
  void dispose() {
    ConnectionStatus.isConnected = true;
    if(!widget.overlay){
      widget.rosService.close();
      widget.stream.closeStream();
    }

    super.dispose();
  }

int count = 0;

  @override
  Widget build(BuildContext context) {
    DateTime actualTime = DateTime.now();
    if(count > 3) count = 0;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {});
      timer.cancel();
    });
    if (ConnectionStatus.isConnected) {
      return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return const Center(
            child: Text("Connection Closed !"),
          );
        }
        if(snapshot.hasData){
          ROSVideoFrame frame = snapshot.data as ROSVideoFrame;
            if(count == 3){
              if (actualTime.second-3 <= frame.timestamp.second) {
                count = 0;
              } else {
                debugPrint("Connection lost");
                ConnectionStatus.isConnected = false;
              }
            }
            count++;

          return Stack(
            children: [
              Image.memory(
                frame.bytes,
                gaplessPlayback: true,
                excludeFromSemantics: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                    child: Text(
                      frame.id,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                    child: Text(
                      frame.timestamp.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const Text("error");
        }
    ,
    );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.1,),
              const CircularProgressIndicator(),
              const Text("Waiting for stream connection", style: TextStyle(color: Colors.white),),
            ],
          ),
      );
    }
  }

}
