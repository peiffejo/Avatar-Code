import 'dart:typed_data';
import 'package:client/communication/models/message.model.dart';

class AudioFrame extends CommunicationMessage {
  final Uint8List bytes;

  AudioFrame(this.bytes, id, timestamp) : super(id, timestamp);
}
