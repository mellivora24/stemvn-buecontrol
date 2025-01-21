import 'package:stemvn_bluecontrol/bluetooth/ble_manager.dart';

class JoystickController {
  final BleManager _bleManager = BleManager();
  
  void onJoystickMove(joystickId, double dx, double dy) {
    // round dx and dy to percentage
    int dxPercent = (dx * 100).toInt();
    int dyPercent = (dy * 100).toInt();

    // format data to send
    String dataTosend = "$joystickId:$dxPercent:$dyPercent";

    print("Sending data: $dataTosend");

    _bleManager.sendData(dataTosend);
  }
}