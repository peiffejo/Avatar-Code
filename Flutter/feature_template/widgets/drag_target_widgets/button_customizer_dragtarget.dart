
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonDragtarget extends StatefulWidget {
  const ButtonDragtarget({super.key});

  @override
  State<ButtonDragtarget> createState() => _ButtonDragtargetState();
}

class _ButtonDragtargetState extends State<ButtonDragtarget> {
  TextEditingController nameOfButton = TextEditingController();
  Icon? _icon;

  _pickIcon() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SizedBox(
                child: TextField(
                  controller: nameOfButton,
                    decoration: InputDecoration(
                      labelText: 'Enter Name',
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: customColor.secondary.withOpacity(0.5),
                        fontWeight: FontWeight.bold,),
                    ),
                    style: TextStyle(
                        fontSize: 15,
                        color: customColor.secondary,
                        fontWeight: FontWeight.bold,),
                 ),
              ),
            ),
            //Textfeld
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    child: IconButton(onPressed: _pickIcon, icon: _icon ?? const Text("Add"))),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
