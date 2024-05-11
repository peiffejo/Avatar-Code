import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Typical Structure for a draggable widget
class DummyDraggable extends StatefulWidget {
  const DummyDraggable({Key? key, required this.dragging})
      : super(key: key);
//The dragging function call-backs to template and informs the parents widget somthing is dragged
  final Function(bool) dragging;

  @override
  State<DummyDraggable> createState() => _DummyDraggableState();
}

class _DummyDraggableState extends State<DummyDraggable> {
  @override
  Widget build(BuildContext context) {
    //value so colorScheme can be changed
    ColorScheme customColor = Theme.of(context).colorScheme;

    //Draggable is the widget which can be dragged around and gives the information values for the drag-target to display the desired widget
    return Draggable(
      //the logic for dragging
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
      //Important Information for drag-target, so drag-target knows what it has to display
      data: const ["smallTile", "dummy"],

      //what will be dragged, (duplication of the displayed Draggable)
      feedback: Material(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: customColor.secondary,
              border: Border.all(color: Colors.grey, width: 2)),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dummy",
                      style: TextStyle(color: customColor.background, fontSize: 12)),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(FontAwesomeIcons.person, color: customColor.background),
                ],
              )),
        ),
      ),

      //what will be displayed at the place the draggable was when the Draggable is dragged away
      childWhenDragging: Container(
        width: 100,
        height: 100,
        color: Theme.of(context).colorScheme.background,
      ),

      //how the Draggable is displayed when it is not dragged
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: customColor.secondary,
            border: Border.all(color: Colors.grey, width: 2)),
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dummy",
                    style: TextStyle(color: customColor.background, fontSize: 12)),
                const SizedBox(
                  height: 10,
                ),
                Icon(FontAwesomeIcons.person, color: customColor.background),
              ],
            )),
      ),
    );
  }
}
