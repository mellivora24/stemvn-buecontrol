import 'package:flutter/material.dart';
import 'dart:math';

class JoystickWidget extends StatefulWidget {
  final Function(double x, double y) onMove; // Hàm callback khi joystick di chuyển

  const JoystickWidget({super.key, required this.onMove});

  @override
  State<JoystickWidget> createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  double _x = 0; // Vị trí X của joystick
  double _y = 0; // Vị trí Y của joystick

  @override
  Widget build(BuildContext context) {
    final double joystickSize = 230; // Đường kính của vùng joystick
    final double joystickRadius = joystickSize / 2; // Bán kính vùng joystick
    final double knobSize = 80; // Kích thước của nút joystick

    return GestureDetector(
      onPanUpdate: (details) {
        // Tính toán vị trí mới
        final offset = Offset(
          _x + details.delta.dx,
          _y + details.delta.dy,
        );

        // Kiểm tra khoảng cách từ tâm (0, 0)
        final distance = offset.distance;

        // Nếu khoảng cách <= bán kính, di chuyển tự do; nếu lớn hơn, giới hạn lại
        if (distance <= joystickRadius - knobSize / 2) {
          setState(() {
            _x = offset.dx;
            _y = offset.dy;
          });
        } else {
          // Giới hạn tại rìa hình tròn
          final angle = atan2(offset.dy, offset.dx);
          setState(() {
            _x = (joystickRadius - knobSize / 2) * cos(angle);
            _y = (joystickRadius - knobSize / 2) * sin(angle);
          });
        }

        // Gửi giá trị chuẩn hóa (-1 đến 1)
        widget.onMove(_x / (joystickRadius - knobSize / 2), _y / (joystickRadius - knobSize / 2));
      },
      onPanEnd: (_) {
        // Trả joystick về vị trí trung tâm khi người dùng thả tay
        setState(() {
          _x = 0;
          _y = 0;
        });
        widget.onMove(0, 0); // Gửi giá trị (0, 0)
      },
      child: Center(
        child: Container(
          width: joystickSize,
          height: joystickSize,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black38, width: 2),
          ),
          child: Stack(
            children: [
              // Nút joystick (nút di chuyển)
              Positioned(
                left: joystickRadius + _x - knobSize / 2,
                top: joystickRadius + _y - knobSize / 2,
                child: Container(
                  width: knobSize,
                  height: knobSize,
                  decoration: BoxDecoration(
                    color: Colors.blue,
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
