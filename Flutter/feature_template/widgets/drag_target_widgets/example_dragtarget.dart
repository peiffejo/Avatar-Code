
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ExampleDragtarget extends StatefulWidget {
  const ExampleDragtarget({super.key});

  @override
  State<ExampleDragtarget> createState() => _ExampleDragtargetState();
}

class _ExampleDragtargetState extends State<ExampleDragtarget> {

  //Here you can design the widget, which can then be seen on the dragtarget
  @override
  Widget build(BuildContext context) {
    //a bool if it is web or mobile
    var widthTile = kIsWeb == true ? 500.0 : 150.0;
    var heightTile = kIsWeb == true ? 450.0 : 150.0;
    ColorScheme customColor = Theme.of(context).colorScheme;
    return Container(
      width: widthTile,
      height: heightTile,
      decoration: BoxDecoration(
        color: customColor.primary,
        border: Border.all(color: customColor.secondary),
      ),
      child: Container()
    );
  }
}
