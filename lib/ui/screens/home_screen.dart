import 'package:flutter/material.dart';
import 'package:stemvn_bluecontrol/ui/widgets/button_widget.dart';
import 'package:stemvn_bluecontrol/ui/widgets/app_bar_widget.dart';
import 'package:stemvn_bluecontrol/ui/widgets/joystick_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isJoystickLeftVisible = true;
  bool _isJoystickRightVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'STEMVN BLUECONTROL'),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlColumn(
            labelUp: "",
            labelDown: "",
            isJoystickVisible: _isJoystickLeftVisible,
            onJoystickMove: (dx, dy) {
              print("Left Joystick moved: dx=$dx, dy=$dy");
            },
            isLeft: true,
          ),
          _buildCenterColumn(),
          _buildControlColumn(
            labelUp: "",
            labelDown: "",
            isJoystickVisible: _isJoystickRightVisible,
            onJoystickMove: (dx, dy) {
              print("Right Joystick moved: dx=$dx, dy=$dy");
            },
            isLeft: false,
          ),
        ],
      ),
    );
  }

  Widget _buildControlColumn({
    required String labelUp,
    required String labelDown,
    required bool isJoystickVisible,
    required Function(double, double) onJoystickMove,
    required bool isLeft,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (labelUp.isNotEmpty)
          ButtonWidget(
            width: 100,
            height: 100,
            label: labelUp,
            onPressed: () => print("UP pressed"),
          ),
        if (labelDown.isNotEmpty)
          ButtonWidget(
            width: 100,
            height: 100,
            label: labelDown,
            onPressed: () => print("DOWN pressed"),
          ),
        isJoystickVisible
            ? JoystickWidget(onMove: onJoystickMove)
            : _buildSwappedContainer(isLeft),
      ],
    );
  }

  Widget _buildSwappedContainer(bool isLeft) {
    if (isLeft) {
      return Container(
        width: 200,
        height: 200,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () => print("LEFT UP pressed"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18.0),
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RawMaterialButton(
                  onPressed: () => print("LEFT LEFT pressed"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18.0),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                RawMaterialButton(
                  onPressed: () => print("LEFT RIGHT pressed"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18.0),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () => print("LEFT DOWN pressed"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18.0),
                  child: const Icon(Icons.arrow_downward, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 200,
        height: 200,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () => print("LEFT UP pressed"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18.0),
                  child: const Icon(Icons.circle_outlined, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RawMaterialButton(
                  onPressed: () => print("LEFT LEFT pressed"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18.0),
                  child: const Icon(Icons.square_outlined, color: Colors.white),
                ),
                RawMaterialButton(
                  onPressed: () => print("LEFT RIGHT pressed"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18.0),
                  child: const Icon(Icons.warning_amber, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () => print("LEFT DOWN pressed"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18.0),
                  child: const Icon(Icons.cancel_presentation_outlined, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCenterColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 230,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border.all(color: Color(0xFFFF7337), width: 3),
          ),
          child: Center(
            child: Text(
              "BLUETOOTH CONNECTED",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
              width: 30,
              height: 120,
              label: "SWAP",
              onPressed: () {
                setState(() {
                  _isJoystickLeftVisible = !_isJoystickLeftVisible;
                  print("SWAP LEFT pressed");
                });
              },
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 50,
              color: Colors.green,
              onPressed: () => print("BLE CONNECT pressed"),
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.stop),
              iconSize: 50,
              color: Colors.red,
              onPressed: () => print("BLE DISCONNECT pressed"),
            ),
            const SizedBox(width: 20),
            ButtonWidget(
              width: 30,
              height: 120,
              label: "SWAP",
              onPressed: () {
                setState(() {
                  _isJoystickRightVisible = !_isJoystickRightVisible;
                  print("SWAP RIGHT pressed");
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
