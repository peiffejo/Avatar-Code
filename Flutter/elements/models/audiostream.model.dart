import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'audioframe.model.dart';

abstract class AudioStreamHandler {
  bool connected;
  bool running;
  final AudioStream stream;
  FlutterSoundPlayer player;

  AudioStreamHandler(this.stream)
      : player = FlutterSoundPlayer(),
        connected = false,
        running = false {
    init();
    startHandler();
  }

  void init() async {
    player.openPlayer(enableVoiceProcessing: false);
    running = true;
    await player.startPlayerFromStream(
        codec: Codec.pcm16, numChannels: 1, sampleRate: 16000);
  }

  void startHandler();
}

abstract class AudioStream extends Stream<AudioFrame> {
  final StreamController<AudioFrame> _controller;

  AudioStream(this._controller);
  void addData(AudioFrame data);
  void closeStream();
  StreamController<AudioFrame> get controller => _controller;
}
