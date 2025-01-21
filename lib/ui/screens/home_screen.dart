import 'package:flutter/material.dart';
import 'package:stemvn_bluecontrol/ui/widgets/button_widget.dart';
import 'package:stemvn_bluecontrol/ui/widgets/app_bar_widget.dart';
import 'package:stemvn_bluecontrol/ui/widgets/joystick_widget.dart';
import 'package:stemvn_bluecontrol/controllers/button_controller.dart';
import 'package:stemvn_bluecontrol/controllers/joystick_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isJoystickLeftVisible = true;
  bool _isJoystickRightVisible = false;

  final double scaleOfButtonContainer = 230;
  final buttonPadding = EdgeInsets.all(24.0);

  bool _isConnected = false;
  late ButtonController _buttonController;
  final JoystickController _joystickController = JoystickController();

  @override
  Widget build(BuildContext context) {
    _buttonController = ButtonController(context);
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
              _joystickController.onJoystickMove("L", dx, -dy);
            },
            isLeft: true,
          ),
          _buildCenterColumn(),
          _buildControlColumn(
            labelUp: "",
            labelDown: "",
            isJoystickVisible: _isJoystickRightVisible,
            onJoystickMove: (dx, dy) {
              _joystickController.onJoystickMove("R", dx, -dy);
            },
            isLeft: false,
          ),
        ],
      ),
    );
  }

  Widget _buildControlColumn({
    required bool isLeft,
    required String labelUp,
    required String labelDown,
    required bool isJoystickVisible,
    required Function(double, double) onJoystickMove,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (labelUp.isNotEmpty)
          ButtonWidget(
            width: 100,
            height: 100,
            label: labelUp,
            onPressed: () => {},
          ),
        if (labelDown.isNotEmpty)
          ButtonWidget(
            width: 100,
            height: 100,
            label: labelDown,
            onPressed: () => {},
          ),
        isJoystickVisible
            ? JoystickWidget( onMove: onJoystickMove )
            : _buildSwappedContainer(isLeft),
      ],
    );
  }

  Widget _buildSwappedContainer(bool isLeft) {
    if (isLeft) {
      return Container(
        width: scaleOfButtonContainer,
        height: scaleOfButtonContainer,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () => _buttonController.onButtonPressed("F"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: buttonPadding,
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RawMaterialButton(
                  onPressed: () => _buttonController.onButtonPressed("L"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: buttonPadding,
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                RawMaterialButton(
                  onPressed: () => _buttonController.onButtonPressed("R"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: buttonPadding,
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () => _buttonController.onButtonPressed("B"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: buttonPadding,
                  child: const Icon(Icons.arrow_downward, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: scaleOfButtonContainer,
        height: scaleOfButtonContainer,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () => _buttonController.onButtonPressed("T"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: buttonPadding,
                  child: const Icon(Icons.circle_outlined, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RawMaterialButton(
                  onPressed: () => _buttonController.onButtonPressed("V"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: buttonPadding,
                  child: const Icon(Icons.crop_square_outlined, color: Colors.white),
                ),
                RawMaterialButton(
                  onPressed: () => _buttonController.onButtonPressed("G"),
                  elevation: 2.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: buttonPadding,
                  child: const Icon(Icons.warning_amber, color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () => _buttonController.onButtonPressed("X"),
                  elevation: 5.0,
                  fillColor: const Color(0xFFFF7337),
                  shape: const CircleBorder(),
                  padding: buttonPadding,
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Container(
          width: 200,
          height: 30,
          decoration: BoxDecoration(
            color: _isConnected ? Colors.green[400] : Colors.red[400],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              _isConnected ? "BLE CONNECTED" : "BLE DISCONNECTED",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ButtonWidget(
              width: 30,
              height: 130,
              label: "SWAP",
              onPressed: () {
                setState(() {
                  _isJoystickLeftVisible = !_isJoystickLeftVisible;
                });
              },
            ),
            const SizedBox(width: 3),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 50,
              color: Colors.green,
              onPressed: () async {
                bool isConnected = await _buttonController.onButtonPressed("CONNECT", state: _isConnected);
                setState(() {
                  _isConnected = isConnected;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              iconSize: 50,
              color: Colors.red,
              onPressed: () async {
                bool isConnected = await _buttonController.onButtonPressed("DISCONNECT", state: _isConnected);
                setState(() {
                  _isConnected = isConnected;
                });
              },
            ),
            const SizedBox(width: 3),
            ButtonWidget(
              width: 30,
              height: 130,
              label: "SWAP",
              onPressed: () {
                setState(() {
                  _isJoystickRightVisible = !_isJoystickRightVisible;
                });
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
