import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScenariosDraggable extends StatefulWidget {
  const ScenariosDraggable({Key? key, required this.dragging})
      : super(key: key);

  final Function(bool) dragging;

  @override
  State<ScenariosDraggable> createState() => _ScenariosDraggableState();
}

class _ScenariosDraggableState extends State<ScenariosDraggable> {
  @override
  Widget build(BuildContext context) {
    ColorScheme customColor = Theme.of(context).colorScheme;
    return Draggable(
      onDragStarted: () {
        setState(() {});
        widget.dragging(true);
      },
      onDragEnd: (details) {
        setState(() {});
        widget.dragging(false);
      },
      onDraggableCanceled: (velocity, offset) {
        setState(() {});
        widget.dragging(false);
      },
      data: const ["mediumTile", "scenarios"],
      //what will be dragged
      feedback: Material(
        child: Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
              color: customColor.secondary,
              border: Border.all(color: Colors.red, width: 2)),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Scenarios",
                      style: TextStyle(color: customColor.background, fontSize: 12)),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(FontAwesomeIcons.globe, color: customColor.background),
                ],
              )),
        ),
      ),
      //what will be left behind
      childWhenDragging: Container(
        width: 200,
        height: 100,
        color: Theme.of(context).colorScheme.background,
      ),
      //default Container
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
            color: customColor.secondary,
            border: Border.all(color: Colors.red, width: 2)),
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Scenarios",
                    style: TextStyle(color: customColor.background, fontSize: 12)),
                const SizedBox(
                  height: 10,
                ),
                Icon(FontAwesomeIcons.globe, color: customColor.background),
              ],
            )),
      ),
    );
  }
}
