import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleManager {
  Future<List<Map<String, String>>> scanDevices() async {
    await _requestPermissions();
    List<Map<String, String>> devices = [];
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        devices.add({
          "name": result.device.name.isNotEmpty ? result.device.name : "Unknown Device",
          "address": result.device.id.id,
        });
      }
    });

    await Future.delayed(const Duration(seconds: 5)); // Chờ quét xong
    FlutterBluePlus.stopScan();
    return devices;
  }

  Future<void> _requestPermissions() async {
    if (await Permission.bluetoothScan.isDenied) await Permission.bluetoothScan.request();
    if (await Permission.bluetoothConnect.isDenied) await Permission.bluetoothConnect.request();
    if (await Permission.location.isDenied) await Permission.location.request();
  }
}
