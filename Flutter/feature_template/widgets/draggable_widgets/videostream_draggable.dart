import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideostreamDraggable extends StatefulWidget {
  const VideostreamDraggable({Key? key, required this.dragging})
      : super(key: key);

  final Function(bool) dragging;

  @override
  State<VideostreamDraggable> createState() => _VideostreamDraggableState();
}

class _VideostreamDraggableState extends State<VideostreamDraggable> {
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
      data: const ["bigTile", "videostream"],
      //what will be dragged
      feedback:  Material(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              color: customColor.secondary,
              border: Border.all(color: Colors.blue, width: 2)),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("VR-Videostream",
                      style: TextStyle(color: customColor.background, fontSize: 12)),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(FontAwesomeIcons.play, color: customColor.background),
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
            border: Border.all(color: Colors.blue, width: 2)),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("VR-Videostream",
                style: TextStyle(color: customColor.background, fontSize: 12)),
            const SizedBox(
              height: 10,
            ),
            Icon(FontAwesomeIcons.play, color: customColor.background),
          ],
        )),
      ), //VideoStreamWidget(),
    );
  }
}
