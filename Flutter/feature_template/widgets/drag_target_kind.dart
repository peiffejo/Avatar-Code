import 'package:client/feature_template/widgets/drag_target_widgets/avatar_controller_dragtarget.dart';
import 'package:client/feature_template/widgets/drag_target_widgets/dummy_dragtarget.dart';
import 'package:client/feature_template/widgets/drag_target_widgets/example_dragtarget.dart';
import 'package:client/feature_template/widgets/drag_target_widgets/ros_audiostream_dragtarget.dart';
import 'package:client/feature_template/widgets/drag_target_widgets/vehicle_position_dragtarget.dart';
import 'package:client/feature_template/widgets/drag_target_widgets/videostream_dragtarget.dart';
import 'package:flutter/material.dart';

import 'drag_target_widgets/button_customizer_dragtarget.dart';
import 'drag_target_widgets/record_audio_dragtarget.dart';
import 'drag_target_widgets/matrix_controller_dragtarget.dart';
import 'drag_target_widgets/ros_message_dragtarget.dart';
import 'drag_target_widgets/ros_videostream_dragtarget.dart';
import 'drag_target_widgets/scenarios_dragtarget.dart';
import 'drag_target_widgets/vehicle_sound_dragtarget.dart';

class DragTargetKind{
  //Get all widgets for dragtargets to be display
  Widget matrix = const MatrixControllerDragtarget();
  Widget avatarController = const AvatarControllerDragtarget();
  Widget downloadAudio = const DownloadAudioDragtarget();
  Widget rosAudioStream = const RosAudiostreamDragtarget();
  Widget rosVideoStream = const RosVideostreamDragtarget();
  Widget videoStream = const VideostreamDragtarget();
  Widget vehicleSound = const VehicleSoundDragtarget();
  Widget scenarios = const ScenariosDragtarget();
  Widget vehiclePosition = const VehiclePositionDragtarget();
  Widget button = const ButtonDragtarget();
  Widget example = const ExampleDragtarget();
  Widget rosmessage = const RosMessageDragtarget();
  Widget dummy = const DummyDragtarget();

  Widget whatKind(List<dynamic> data) {
    if(data[0] == "bigTile" && data[1] == "ros-videostream"){
      return rosVideoStream;
    }
    if(data[0] == "bigTile" && data[1] == "videostream"){
      return videoStream;
    }
    if(data[0] == "bigTile" && data[1] == "vehicleSound"){
      return vehicleSound;
    }
    if(data[0] == "mediumTile" && data[1] == "scenarios"){
      return scenarios;
    }
    if(data[0] == "mediumTile" && data[1] == "ros-audiostream"){
      return rosAudioStream;
    }
    if(data[0] == "smallTile" && data[1] == "vehiclePosition"){
      return vehiclePosition;
    }
    if(data[0] == "smallTile" && data[1] == "button"){
      return button;
    }
    if(data[0] == "smallTile" && data[1] == "example"){
      return example;
    }
    if(data[0] == "mediumTile" && data[1] == "ros-message"){
      return rosmessage;
    }
    if(data[0] == "smallTile" && data[1] == "downloadAudio"){
      return downloadAudio;
    }
    if(data[0] == "bigTile" && data[1] == "avatar-controller"){
      return avatarController;
    }
    if(data[0] == "smallTile" && data[1] == "dummy"){
      return dummy;
    }
    if(data[0] == "bigTile" && data[1] == "matrix"){
      return matrix;
    }
    return Container();
  }



}