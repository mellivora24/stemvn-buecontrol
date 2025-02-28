import 'package:stemvn_bluecontrol/bluetooth/ble_manager.dart';

class JoystickController {
  final BleManager _bleManager; // Nhận từ ngoài
  DateTime _lastSent = DateTime.now();
  final Duration _throttleDuration = Duration(milliseconds: 50);

  JoystickController(this._bleManager); // Constructor

  void onJoystickMove(String joystickId, double dx, double dy) {
    DateTime now = DateTime.now();
    if (now.difference(_lastSent) < _throttleDuration) {
      print("Joystick throttle active, skipping: $joystickId"); // Debug throttle
      return;
    }

    int dxPercent = (dx * 100).toInt().clamp(-100, 100);
    int dyPercent = (dy * 100).toInt().clamp(-100, 100);
    String dataToSend = "$joystickId$dxPercent:$dyPercent";

    print("Joystick sending: $dataToSend"); // Debug trước khi gửi
    _bleManager.sendData(dataToSend);
    _lastSent = now;
  }
}