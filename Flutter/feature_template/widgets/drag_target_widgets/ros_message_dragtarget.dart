import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RosMessageDragtarget extends StatefulWidget {
  const RosMessageDragtarget({super.key});

  @override
  State<RosMessageDragtarget> createState() => _RosMessageDragtargetState();
}

class _RosMessageDragtargetState extends State<RosMessageDragtarget> {
  TextEditingController nameOfAction = TextEditingController();
  TextEditingController nameOfActionService = TextEditingController();
  TextEditingController nameOfActionTarget = TextEditingController();

  TextEditingController nameOfElement = TextEditingController();
  TextEditingController nameOfTopic = TextEditingController();
  TextEditingController nameOfDatatype = TextEditingController();

  //Here you can design the widget, which can then be seen on the dragtarget
  @override
  Widget build(BuildContext context) {
    //a bool if it is web or mobile
    var widthTile = kIsWeb == true ? 500.0 : 200.0;
    var heightTile = kIsWeb == true ? 450.0 : 100.0;
    ColorScheme customColor = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Container(
          width: widthTile,
          height: heightTile,
          decoration: BoxDecoration(
            color: customColor.primary,
            border: Border.all(color: customColor.secondary),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ROS Setup", style: TextStyle(color: customColor.secondary)),
              IconButton(
                onPressed: () {showOverlay(context);}, icon: Icon(FontAwesomeIcons.toolbox, color: Theme.of(context).colorScheme.secondary,),
              ),
            ],
          )
      ),
    );
  }


  void showOverlay(BuildContext context) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    _removeOverlay(overlayEntry!);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 100.0),
                      child: Container(
                                      color: const Color.fromARGB(100, 200, 200, 200),
                                      child:Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,
                                              border: Border.all(
                                                color: Theme.of(context).colorScheme.secondary, // Border color
                                                width: 1.0, // Border width
                                              ), // Border radius
                                            ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(" Ros-Message Configuration", style: TextStyle(decoration: TextDecoration.none, color: Colors.black, fontSize: 20)),
                            GestureDetector(
                              onTap: (){
                                _removeOverlay(overlayEntry!);
                              },
                              child: const Align(
                                  alignment: Alignment.bottomRight,child: Icon(FontAwesomeIcons.x)),
                            ),
                            const SizedBox(width: 2,),
                          ],
                        ),
                      ),
                                          ),
                                          Expanded(
                      child: Material(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary, // Border color
                              width: 1.0, // Border width
                            ), // Border radius
                          ),
                          child: Column(
                            children: [
                              textFieldInput(context, nameOfElement, 'Enter a Name'),
                              textFieldInput(context, nameOfTopic, 'Enter a Ros Topic'),
                              textFieldInput(context, nameOfDatatype, 'Enter a Ros Datatype'),
                              const SizedBox(height: 10,),

                              Container(
                                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.secondary, // Border color
                                    width: 1.0, // Border width
                                  ), // Border radius
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(" Action Configuration ID: ", style: TextStyle(decoration: TextDecoration.none, color: Colors.black, fontSize: 20)),
                                    ],
                                  ),
                                ),
                              ),

                              textFieldInput(context, nameOfAction, 'Enter a action name'),

                            ],
                          ),
                        ),
                      ),
                                          ),
                                        ],
                                      )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
    Overlay.of(context).insert(overlayEntry);
  }

  void _removeOverlay(OverlayEntry overlayEntry) {
    overlayEntry.remove();
  }

  Widget textFieldInput(BuildContext context, TextEditingController controller, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: SizedBox(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: text,
            border: InputBorder.none,
            labelStyle: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,),
        ),
      ),
    );
  }
}
