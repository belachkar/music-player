import 'dart:math';
import 'package:flutter/material.dart';

import 'songs.dart';
import 'Bottom_controls.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      // showSemanticsDebugger: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          color: const Color(0xFFDDDDDD),
          onPressed: () {},
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            color: const Color(0xFFDDDDDD),
            onPressed: () {},
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          // Seek bar
          new Expanded(
            child: new Center(
              child: new Container(
                width: 125.0,
                height: 125.0,
                child: RadialSeekBar(
                  progressPercent: 0.2,
                  thumbPosition: 0.2,
                  child: ClipOval(
                    clipper: new CircleClipper(),
                    child: new Image.network(
                      demoPlayList.songs[0].albumArtUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Visualizer
          new Container(
            width: double.infinity,
            height: 125.0,
            color: Colors.blue,
          ),

          // Son title, artist name, and controls
          new BottomControls(),
        ],
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: new Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class RadialSeekBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final Widget child;

  const RadialSeekBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.grey,
    this.progressWidth = 5.0,
    this.progressColor = Colors.black,
    this.progressPercent = 0.0,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.black,
    this.thumbPosition = 0.0,
    this.child,
  });

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      foregroundPainter: new RadialSeekBarPainter(
        trackWidth: widget.trackWidth,
        trackColor: widget.trackColor,
        progressWidth: widget.progressWidth,
        progressColor: widget.progressColor,
        progressPercent: widget.progressPercent,
        thumbSize: widget.thumbSize,
        thumbColor: widget.thumbColor,
        thumbPosition: widget.thumbPosition
      ),
      child: widget.child,
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final Paint progressPaint;
  final double progressPercent;
  final double thumbSize;
  final Paint thumbPaint;
  final double thumbPosition;

  RadialSeekBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.progressPercent,
    @required this.thumbSize,
    @required thumbColor,
    @required this.thumbPosition
  }) : trackPaint = new Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth,
      progressPaint = new Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = progressWidth
        ..strokeCap = StrokeCap.round,
      thumbPaint = new Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Track params
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Progress prams
    final startAngle = -pi / 2;
    final sweepAngle = pi * 2 * progressPercent;
    final bounds = new Rect.fromCircle(center: center, radius: radius);

    // Thumb params
    final thumbRadius = thumbSize / 2.0;
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(thumbX, thumbY) + center;

    // Paint track
    canvas.drawCircle(center, radius, trackPaint);

    // Paint progress
    canvas.drawArc(bounds, startAngle, sweepAngle, false, progressPaint);

    // Paint thumb
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
