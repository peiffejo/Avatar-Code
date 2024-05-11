import 'dart:async';

import 'package:client/feature_template/widgets/drag_target_widgets/view_connect.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


const type = String.fromEnvironment('type');

class VideostreamDragtarget extends StatefulWidget {
  const VideostreamDragtarget({Key? key}) : super(key: key);

  @override
  State<VideostreamDragtarget> createState() => _VideostreamDragtargetState();
}

class _VideostreamDragtargetState extends State<VideostreamDragtarget> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  StreamController<bool> controller1 = StreamController<bool>.broadcast();
  bool isVisible = false;
  late Stream stream = controller1.stream;

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
    subscribeExample();
  }

  void subscribeExample() async {
    await viewConnect(_localRenderer);
    setState(() {});
  }

  void initRenderers() async {
    await _localRenderer.initialize();
  }



  @override
  Widget build(BuildContext context) {
    var widthTile = kIsWeb == true ? 500.0 : 300.0;
    var heightTile = kIsWeb == true ? 450.0 : 200.0;
    ColorScheme customColor = Theme.of(context).colorScheme;
    return StreamBuilder<dynamic>(
      stream: stream,
      builder: (context, snapshot) {
        return isVisible ?  Container(
          width: widthTile,
          height: heightTile,
          decoration: BoxDecoration(
            color: customColor.primary,
            border: Border.all(color: customColor.secondary),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Settings", style: TextStyle(color: customColor.secondary, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          isVisible = !isVisible;
                          controller1.add(isVisible);
                        }, icon: Icon(FontAwesomeIcons.x, color: customColor.secondary,),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("IP Adress"),
                ),
                TextField(controller: TextEditingController(text: "192.0.0.0.80"),decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                  ),
                ),),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Camera"),
                ),
                TextField(decoration: InputDecoration(
                  hintStyle: TextStyle(color: customColor.secondary.withOpacity(0.5)),
                  hintText: " Choose Camera",
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Edit"),
                ),
                TextField(controller: TextEditingController(text: ""),decoration: InputDecoration(
                  hintStyle: TextStyle(color: customColor.secondary.withOpacity(0.5)),
                  hintText: " Customize",
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                ),

              ],
            ),
          ),
        ) : Container(
          width: widthTile,
          height: heightTile,
          color: customColor.secondary.withOpacity(0.9),
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
                  IconButton(
                    onPressed: () {
                      isVisible = !isVisible;
                      controller1.add(isVisible);
                      }, icon: Icon(FontAwesomeIcons.ellipsisVertical, color: Theme.of(context).colorScheme.background,),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                width: widthTile*0.85,
                height: heightTile*0.8,
                decoration: const BoxDecoration(color: Colors.black54),
                child: RTCVideoView(_localRenderer, mirror: true),
              ),
            ],
          ),
        );
      }
    );
  }

  void showOverlay(BuildContext context) {
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
                      child: Text("Video-Stream", style: TextStyle(color: Colors.black, fontSize: 20)),
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
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: RTCVideoView(_localRenderer,),
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
