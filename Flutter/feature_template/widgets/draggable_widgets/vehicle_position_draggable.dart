import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VehiclePositionDraggable extends StatefulWidget {
  const VehiclePositionDraggable({Key? key, required this.dragging})
      : super(key: key);

  final Function(bool) dragging;

  @override
  State<VehiclePositionDraggable> createState() => _VehiclePositionDraggableState();
}

class _VehiclePositionDraggableState extends State<VehiclePositionDraggable> {
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
      data: const ["smallTile", "vehiclePosition"],
      //what will be dragged
      feedback: Material(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: customColor.secondary,
              border: Border.all(color: Colors.greenAccent, width: 2)),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Vehicle Position",
                      style: TextStyle(color: customColor.background, fontSize: 10)),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(FontAwesomeIcons.locationDot, color: customColor.background),
                ],
              )),
        ),
      ),
      //what will be left behind
      childWhenDragging: Container(
        width: 100,
        height: 100,
        color: Theme.of(context).colorScheme.background,
      ),
      //default Container
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: customColor.secondary,
            border: Border.all(color: Colors.greenAccent, width: 2)),
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vehicle Position",
                    style: TextStyle(color: customColor.background, fontSize: 10)),
                const SizedBox(
                  height: 10,
                ),
                Icon(FontAwesomeIcons.locationDot, color: customColor.background),
              ],
            )),
      ),
    );
  }
}
