import 'dart:convert';
import 'dart:typed_data';

import 'package:client/communication/models/message.model.dart';

class VideoFrame extends CommunicationMessage {
  final Uint8List bytes;

  VideoFrame(this.bytes, id, timestamp) : super(id, timestamp);

  VideoFrame.fromJson(Map<String, dynamic> json)
      : bytes = base64.decode(json['data']),
        super(json['id'], json['timestamp']);
}

abstract class VideoStream extends Stream<VideoFrame> {
  void addData(VideoFrame data);
  void closeStream();
}
