import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleManager {
  BluetoothDevice? _currentDevice;
  BluetoothCharacteristic? _writeCharacteristic;

  // Quét thiết bị
  Future<List<Map<String, String>>> scanDevices() async {
    await _requestPermissions();

    List<Map<String, String>> devices = [];
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 3));

    FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (!devices.any((device) => device["address"] == result.device.id.id)) {
          devices.add({
            "name": result.device.name.isNotEmpty ? result.device.name : "Unknown Device",
            "address": result.device.id.id,
          });
        }
      }
    });

    await Future.delayed(const Duration(seconds: 3));
    FlutterBluePlus.stopScan();
    return devices;
  }

  // Kết nối với thiết bị và lưu đặc tính để sử dụng lại
  Future<bool> connect(String deviceAddress) async {
    try {
      _currentDevice = BluetoothDevice.fromId(deviceAddress);
      await _currentDevice!.connect();

      // Lưu đặc tính gửi dữ liệu để sử dụng lại
      List<BluetoothService> services = await _currentDevice!.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid == Guid('0000FFE0-0000-1000-8000-00805F9B34FB')) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid == Guid('0000FFE1-0000-1000-8000-00805F9B34FB')) {
              _writeCharacteristic = characteristic;
              break;
            }
          }
        }
      }

      return _writeCharacteristic != null;
    } catch (e) {
      return false;
    }
  }

  // Ngắt kết nối với thiết bị
  Future<bool> disconnect() async {
    try {
      if (_currentDevice != null) {
        await _currentDevice!.disconnect();
        _currentDevice = null;
        _writeCharacteristic = null;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  // Gửi dữ liệu (với đặc tính đã lưu)
  Future<void> sendData(String data) async {
    if (_writeCharacteristic != null) {
      try {
        List<int> bytes = data.codeUnits;

        // Gửi dữ liệu với chế độ không yêu cầu phản hồi
        await _writeCharacteristic!.write(bytes, withoutResponse: true);
      } catch (e) {
        print("Error sending data: $e");
      }
    } else {
      print("No write characteristic available.");
    }
  }

  // Yêu cầu quyền Bluetooth và location
  Future<void> _requestPermissions() async {
    if (await Permission.location.isDenied) await Permission.location.request();
    if (await Permission.bluetoothScan.isDenied) await Permission.bluetoothScan.request();
    if (await Permission.bluetoothConnect.isDenied) await Permission.bluetoothConnect.request();
  }
}
