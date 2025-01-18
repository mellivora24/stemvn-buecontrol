import 'package:flutter/material.dart';
import 'dart:math';

class JoystickWidget extends StatefulWidget {
  final Function(double x, double y) onMove;
  const JoystickWidget({super.key, required this.onMove});

  @override
  State<JoystickWidget> createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  double _x = 0;
  double _y = 0;

  @override
  Widget build(BuildContext context) {
    final double knobSize = 80;
    final double joystickSize = 200;
    final double joystickRadius = joystickSize / 2;

    return GestureDetector(
      onPanUpdate: (details) {
        final offset = Offset(
          _x + details.delta.dx,
          _y + details.delta.dy,
        );

        final distance = offset.distance;

        if (distance <= joystickRadius - knobSize / 2) {
          setState(() {
            _x = offset.dx;
            _y = offset.dy;
          });
        } else {
          final angle = atan2(offset.dy, offset.dx);
          setState(() {
            _x = (joystickRadius - knobSize / 2) * cos(angle);
            _y = (joystickRadius - knobSize / 2) * sin(angle);
          });
        }

        widget.onMove(_x / (joystickRadius - knobSize / 2), _y / (joystickRadius - knobSize / 2));
      },
      onPanEnd: (_) {
        setState(() {
          _x = 0;
          _y = 0;
        });
        widget.onMove(0, 0);
      },
      child: Center(
        child: Container(
          width: joystickSize,
          height: joystickSize,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFFF7337), width: 2),
          ),
          child: Stack(
            children: [
              Positioned(
                left: joystickRadius + _x - knobSize / 2,
                top: joystickRadius + _y - knobSize / 2,
                child: Container(
                  width: knobSize,
                  height: knobSize,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF7337),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
