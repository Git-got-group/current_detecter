import 'package:flutter/material.dart';
import 'dart:math' as math;

class Compass extends StatelessWidget {
  final double rotation; // Angle in degrees

  const Compass({super.key, required this.rotation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Compass circle
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent, width: 3),
          ),
        ),
        // Arrow indicator
        Transform.rotate(
          angle: (rotation * math.pi) / 180, // Convert degrees to radians
          child: Icon(
            Icons.compass_calibration_sharp,
            size: 25,
            color: Colors.red,
          ),
        ),
        // Cardinal directions
        Positioned(
          top: 8,
          left: 50,
          child: Text(
            'N',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 50,
          child: Text(
            'S',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          left: 20,
          top: 36,
          child: Text(
            'W',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          right: 20,
          top: 36,
          child: Text(
            'E',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
