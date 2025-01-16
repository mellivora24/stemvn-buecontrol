import 'package:flutter/material.dart';
import 'package:stemvn_bluecontrol/ui/widgets/joystick_widget.dart';
import 'package:stemvn_bluecontrol/ui/widgets/button_widget.dart';
import 'package:stemvn_bluecontrol/ui/widgets/status_indicator.dart';
import 'package:stemvn_bluecontrol/ui/widgets/app_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'STEMVN BlueControl',
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () {
              print('Bluetooth button pressed');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                JoystickWidget(
                  onMove: (x, y) {
                    print('Giá trị JOYSTICK: X=$x, Y=$y');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusIndicator(),
                const SizedBox(height: 16),
                ButtonWidget(
                  label: 'Button 1',
                  onPressed: () {
                    print('Button 1 pressed');
                  },
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  label: 'Button 2',
                  onPressed: () {
                    print('Button 2 pressed');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
