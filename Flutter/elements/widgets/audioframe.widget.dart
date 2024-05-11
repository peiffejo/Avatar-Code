import 'dart:typed_data';
import 'package:client/ros/models/audio.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../models/audiostream.model.dart';

// ignore: must_be_immutable
class AudioStreamWidget extends StatelessWidget {
  AudioStreamHandler audioHandler;
  int maxDelay = 0;

  AudioStreamWidget(this.audioHandler, {super.key});

  @override
  Widget build(BuildContext context) {
    return (audioHandler.connected && audioHandler.running)
        ? StreamBuilder(
            stream: audioHandler.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Connecting..."),
                    SizedBox(height: 30,),
                    LinearProgressIndicator(color: Colors.blue,),
                  ],
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return const Center(
                  child: Text("Connection Closed !"),
                );
              }
              ROSAudioFrame frame = snapshot.data as ROSAudioFrame;
              audioHandler.player.foodSink!.add(FoodData(frame.bytes));
              return Stack(
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 200),
                    painter: WaveformPainter(frame.bytes, const Color.fromARGB(255, 160, 12, 12)),
                  ) ,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      overlayWidget(frame.id),
                      //overlayWidget(frame.timestamp.toString()),
                      overlayWidget(frame.timestamp
                          .difference(DateTime.now())
                          .inMilliseconds
                          .toString())
                    ],
                  ),
                ],
              );
            },
          )
        : const Text("Waiting for stream connection");
  }

  Widget overlayWidget(String text) {
    return Container(
      padding: const EdgeInsets.all(5),
      color: const Color.fromRGBO(0, 0, 0, 0.2),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class AudioPainter extends CustomPainter {
  final Uint8List audioData;
  final int barAmount;
  final Color barColor;
  final Color backgroundColor;

  AudioPainter(
      {required this.audioData,
      required this.barAmount,
      this.backgroundColor = Colors.white,
      this.barColor = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final barWidth = (size.width - 40) / (barAmount + 2);
    final barSpacing = barWidth / 2;
    const borderRadius = Radius.circular(10); // Round corner radius
    if (audioData.isEmpty) {
      canvas.drawColor(Colors.transparent, BlendMode.clear); // Clear the canvas
    } else {
      for (var i = 0; i < barAmount; i++) {
        final dataIndex = (i * audioData.length ~/ barAmount)
            .toInt(); // Calculate the data index for each bar
        final barHeight = audioData[dataIndex].toDouble() /
            255 *
            (size.height - 40); // Subtract padding from the available height
        final rect = Rect.fromLTRB(
          i * (barWidth + barSpacing) + 20, // Add padding on the left side
          size.height - barHeight - 20, // Add padding on the bottom side
          (i + 1) * barWidth +
              i * barSpacing +
              20, // Add padding on the right side
          size.height - 20, // Add padding on the top side
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, borderRadius),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WaveformPainter extends CustomPainter {
  final List<int> audioData;
  final Color color;
  final double threshold;

  WaveformPainter(this.audioData, this.color, {this.threshold = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    final numPoints = size.width.toInt();

    final dx = size.width / numPoints;
    final dy = size.height;

    var lastX = 0.0;
    var lastY = 0.0;

    final bytesPerPixel = audioData.length ~/ numPoints;

    for (int i = 0; i < numPoints - 1; i++) {
      final x1 = i * dx;
      final x2 = (i + 1) * dx;

      final startIndex = i * bytesPerPixel;
      final endIndex = (i + 1) * bytesPerPixel;

      final byteData = audioData.sublist(startIndex, endIndex);
      final volume = byteData.reduce((value, element) => value + element) / (byteData.length * 255); // Normalize to [0, 1]

      final y1 = dy - volume * dy;
      final y2 = dy - volume * dy;

      // Draw a line segment
      if (lastX != 0.0 && lastY != 0.0) {
        canvas.drawLine(Offset(lastX, lastY), Offset(x1, y1), paint);
      }
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      lastX = x2;
      lastY = y2;
    }
  }



  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.audioData != audioData;
  }
}
