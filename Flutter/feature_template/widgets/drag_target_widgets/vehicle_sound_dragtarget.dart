import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class VehicleSoundDragtarget extends StatefulWidget {
  const VehicleSoundDragtarget({super.key});

  @override
  State<VehicleSoundDragtarget> createState() => _VehicleSoundDragtargetState();
}

class _VehicleSoundDragtargetState extends State<VehicleSoundDragtarget> {
  StreamController<double> controller1 = StreamController<double>.broadcast();
  late Stream stream = controller1.stream;
  bool sound = true;

  @override
  Widget build(BuildContext context) {
    var widthTile = kIsWeb == true ? 500.0 : 300.0;
    var heightTile = kIsWeb == true ? 450.0 : 350.0;
    ColorScheme customColor = Theme.of(context).colorScheme;
    return StreamBuilder<dynamic>(
      stream: stream,
      builder: (context, snapshot) {
        return Container(
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
                      child: Text("Auto Sound / Vehicle Sound",
                          style: TextStyle(
                              color: customColor.secondary,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text("Sound ${sound ? "On" : "Off"}"),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: sound,
                      onChanged: (bool value) {
                        setState(() {
                          sound = value;
                        });
                      },
                      activeTrackColor:
                          Theme.of(context).colorScheme.secondary.withGreen(200),
                    ),
                  ),
                ]),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Sprache / Language"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                  child: ToggleSwitch(
                    minWidth: 100.0,
                    minHeight: 30.0,
                    fontSize: 12.0,
                    initialLabelIndex: 0,
                    cornerRadius: 10.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['German', 'English'],
                    icons: const [Icons.flag, Icons.flag_outlined],
                    activeBgColors: const [[Colors.green],[Colors.green]],
                    onToggle: (index) {
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Sprecher / Speaker"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                  child: ToggleSwitch(
                    minWidth: 100.0,
                    minHeight: 30.0,
                    fontSize: 12.0,
                    initialLabelIndex: 0,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['Male', 'Female'],
                    icons: const [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                    activeBgColors: const [[Colors.blue],[Colors.pink]],
                    onToggle: (index) {
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Lautstärke / Volume"),
                ),
                Slider(
                  value: snapshot.data ?? 0.0 ,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: snapshot.data == null ? "0.0" : snapshot.data.round().toString(),
activeColor: Theme.of(context).colorScheme.secondary.withGreen(200).withOpacity(0.5),
                  thumbColor: Colors.green,
                  inactiveColor: customColor.background.withAlpha(250),
                  onChanged: (double value) {
                    setState(() {
                      controller1.add(value);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
