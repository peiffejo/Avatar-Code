import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VehicleSoundDraggable extends StatefulWidget {
  const VehicleSoundDraggable({Key? key, required this.dragging})
      : super(key: key);

  final Function(bool) dragging;

  @override
  State<VehicleSoundDraggable> createState() => _VehicleSoundDraggableState();
}

class _VehicleSoundDraggableState extends State<VehicleSoundDraggable> {
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
      data: const ["bigTile", "vehicleSound"],
      //what will be dragged
      feedback: Material(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              color: customColor.secondary,
              border: Border.all(color: Colors.yellow, width: 2)),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Vehicle Sound",
                      style: TextStyle(color: customColor.background, fontSize: 12)),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(FontAwesomeIcons.music, color: customColor.background),
                ],
              )),
        ),
      ),
      //what will be left behind
      childWhenDragging: Container(
        width: 150,
        height: 150,
        color: Theme.of(context).colorScheme.background,
      ),
      //default Container
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            color: customColor.secondary,
            border: Border.all(color: Colors.yellow, width: 2)),
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vehicle Sound",
                    style: TextStyle(color: customColor.background, fontSize: 12)),
                const SizedBox(
                  height: 10,
                ),
                Icon(FontAwesomeIcons.music, color: customColor.background),
              ],
            )),
      ),
    );
  }
}
