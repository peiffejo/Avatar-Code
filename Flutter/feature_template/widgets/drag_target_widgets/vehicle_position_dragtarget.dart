import 'dart:async';

import 'package:client/components/number_imput.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VehiclePositionDragtarget extends StatefulWidget {
  const VehiclePositionDragtarget({super.key});

  @override
  State<VehiclePositionDragtarget> createState() => _VehiclePositionDragtargetState();
}

class _VehiclePositionDragtargetState extends State<VehiclePositionDragtarget> {
  StreamController<double> controller1 = StreamController<double>.broadcast();
  late Stream stream = controller1.stream;
  bool sound = true;

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 50,
                            child: Text("Vehicle Position ",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: customColor.secondary,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 5,),
                          const NumberInput(label: 'x'),
                          const SizedBox(height: 5,),
                          const NumberInput(label: 'y'),
                          const SizedBox(height: 5,),
                          const NumberInput(label: 'z'),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 50,
                            child: Text("Vehicle Rotation ",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: customColor.secondary,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 5,),
                          const NumberInput(label: 'x'),
                          const SizedBox(height: 5,),
                          const NumberInput(label: 'y'),
                          const SizedBox(height: 5,),
                          const NumberInput(label: 'z'),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
}
