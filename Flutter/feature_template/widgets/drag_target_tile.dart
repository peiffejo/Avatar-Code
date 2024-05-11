import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'drag_target_kind.dart';

//detects which size the draggable has and if allowed on drag-target
class DragTargetTile {
  DragTargetTile();

  //Getter for different kinds of widget for the drag-target
  DragTargetKind dragTargetKind = DragTargetKind();
  bool acceptedHover = false;
  List<String> dataList = [];
  Color tileColor = const Color.fromARGB(181, 245, 245, 245);
  bool isVisible = false;
  bool gotData = false;
  StreamController<bool> controller = StreamController<bool>.broadcast();
  late Stream stream = controller.stream;

  //Default-Style for different dragtarget size, has a Stream attached so that visual feedback
    //can be given to the user, regarding draggable allowed on dragtarget or not

  late Widget dragTargetBigTile = StreamBuilder<dynamic>(
      stream: stream,
      builder: (context, state) {
        return DragTarget(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return acceptedHover
                ? GestureDetector(
                    onLongPress: () {
                      isVisible = !isVisible;
                      controller.add(isVisible);
                    },
                    child: Stack(
                      children: [
                        dragTargetKind.whatKind(dataList),
                        Visibility(
                          visible: isVisible,
                          child: Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(200),
                              ),
                              child: IconButton(
                                iconSize: 30,
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                ),
                                onPressed: () {
                                  //Reset all variables and (stream)controller rebuilds stream-builder to update the tile
                                  isVisible = false;
                                  gotData = false;
                                  acceptedHover = false;
                                  dataList = [];
                                  tileColor =
                                      const Color.fromARGB(181, 245, 245, 245);
                                  controller.add(isVisible);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
                : Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: tileColor,
                      border: Border.all(
                        color: Colors.black,
                        width: 0.05,
                      ),
                    ),
                  );
          },
          onMove: (data) {
            if (dataList[0] == "bigTile") {
              tileColor = const Color.fromARGB(100, 255, 0, 0);
            }
          },
          onLeave: (data) {
            tileColor = const Color.fromARGB(181, 245, 245, 245);
          },
          onWillAccept: (data) {
            if (gotData) return false;
            if (data == null) return false;
            dataList = data as List<String>;
            if (dataList[0] == "bigTile") {
              return true;
            } else {
              return false;
            }
          },
          onAccept: (data) {
            acceptedHover = true;
            gotData = true;
          },
        );
      });

  late Widget dragTargetMediumTile = StreamBuilder<dynamic>(
      stream: stream,
      builder: (context, state) {
        return DragTarget(
          builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
              ) {
            return acceptedHover
                ? GestureDetector(
                onLongPress: () {
                  isVisible = !isVisible;
                  controller.add(isVisible);
                },
                child: Stack(
                  children: [
                    dragTargetKind.whatKind(dataList),
                    Visibility(
                      visible: isVisible,
                      child: Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            iconSize: 30,
                            icon: const Icon(
                              FontAwesomeIcons.trash,
                            ),
                            onPressed: () {
                              //Reset all variables and (stream)controller rebuilds stream for update the tile
                              gotData = false;
                              acceptedHover = false;
                              isVisible = false;
                              dataList = [];
                              tileColor =
                              const Color.fromARGB(181, 245, 245, 245);
                              controller.add(isVisible);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
                : Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: tileColor,
                border: Border.all(
                  color: Colors.black,
                  width: 0.05,
                ),
              ),
            );
          },
          onMove: (data) {
            if (dataList[0] == "mediumTile") {
              tileColor = const Color.fromARGB(100, 255, 0, 0);
            }
          },
          onLeave: (data) {
            tileColor = const Color.fromARGB(181, 245, 245, 245);
          },
          onWillAccept: (data) {
            //check if tile already has widget
            if (gotData) return false;
            //safety against bugs
            if (data == null) return false;
            dataList = data as List<String>;
            if (dataList[0] == "mediumTile") {
              return true;
            } else {
              return false;
            }
          },
          onAccept: (data) {
            acceptedHover = true;
            gotData = true;
          },
        );
      });

  late Widget dragTargetSmallTile = StreamBuilder<dynamic>(
      stream: stream,
      builder: (context, state) {
        return DragTarget(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return acceptedHover
                ? GestureDetector(
                    onLongPress: () {
                      isVisible = !isVisible;
                      controller.add(isVisible);
                    },
                    child: Stack(
                      children: [
                        dragTargetKind.whatKind(dataList),
                        Visibility(
                          visible: isVisible,
                          child: Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: IconButton(
                                iconSize: 30,
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                ),
                                onPressed: () {
                                  //Reset all variables and (stream)controller rebuilds stream for update the tile
                                  gotData = false;
                                  acceptedHover = false;
                                  isVisible = false;
                                  dataList = [];
                                  tileColor =
                                  const Color.fromARGB(181, 245, 245, 245);
                                  controller.add(isVisible);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
                : Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: tileColor,
                      border: Border.all(
                        color: Colors.black,
                        width: 0.05,
                      ),
                    ),
                  );
          },
          onMove: (data) {
            if (dataList[0] == "smallTile") {
              tileColor = const Color.fromARGB(100, 255, 0, 0);
            }
          },
          onLeave: (data) {
            tileColor = const Color.fromARGB(181, 245, 245, 245);
          },
          onWillAccept: (data) {
            //check if tile already has widget
            if (gotData) return false;
            //safety against bugs
            if (data == null) return false;
            dataList = data as List<String>;
            if (dataList[0] == "smallTile") {
              return true;
            } else {
              return false;
            }
          },
          onAccept: (data) {
            acceptedHover = true;
            gotData = true;
          },
        );
      });
}
