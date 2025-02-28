import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleManager {
  BluetoothDevice? _currentDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  int _mtu = 23;

  Future<void> _requestPermissions() async {
    await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  Future<List<Map<String, String>>> scanDevices() async {
    await _requestPermissions();
    final List<Map<String, String>> devices = [];

    final scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        if (!devices.any((device) => device["address"] == result.device.id.id)) {
          devices.add({
            "name": result.device.name.isNotEmpty ? result.device.name : "Unknown Device",
            "address": result.device.id.id,
          });
        }
      }
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 3));
    await Future.delayed(const Duration(seconds: 3));
    await FlutterBluePlus.stopScan();
    await scanSubscription.cancel();

    return devices;
  }

  Future<bool> connect(String deviceAddress) async {
    try {
      _currentDevice = BluetoothDevice.fromId(deviceAddress);
      await _currentDevice!.connect();

      final services = await _currentDevice!.discoverServices();
      for (final service in services) {
        if (service.uuid == Guid('0000FFE0-0000-1000-8000-00805F9B34FB')) {
          for (final characteristic in service.characteristics) {
            if (characteristic.uuid == Guid('0000FFE1-0000-1000-8000-00805F9B34FB')) {
              _writeCharacteristic = characteristic;
              break;
            }
          }
        }
      }

      _mtu = await _currentDevice!.requestMtu(512);
      print("Negotiated MTU: $_mtu");
      print("Characteristic properties: write=${_writeCharacteristic?.properties.write}, writeNoResponse=${_writeCharacteristic?.properties.writeWithoutResponse}");
      return true;
    } catch (e) {
      print("Error connecting to device: $e");
      return false;
    }
  }

  Future<bool> disconnect() async {
    try {
      if (_currentDevice == null) return true;
      await _currentDevice!.disconnect();
      _currentDevice = null;
      _writeCharacteristic = null;
      return true;
    } catch (e) {
      print("Error disconnecting device: $e");
      return false;
    }
  }

  Future<void> sendData(String data) async {
    if (_currentDevice == null || _writeCharacteristic == null) {
      print("Cannot send data: Not connected or characteristic not found");
      return;
    }

    print("Sending data via BLE: $data"); // Log rõ ràng hơn

    try {
      String message = '$data\n'; // Đã có \n từ JoystickController
      final chunkSize = _mtu - 3;

      if (message.length <= chunkSize) {
        bool useNoResponse = _writeCharacteristic!.properties.writeWithoutResponse;
        await _writeCharacteristic!.write(
          message.codeUnits,
          withoutResponse: useNoResponse,
        );
      } else {
        for (var i = 0; i < message.length; i += chunkSize) {
          final end = (i + chunkSize < message.length) ? i + chunkSize : message.length;
          final chunk = message.substring(i, end);
          bool useNoResponse = _writeCharacteristic!.properties.writeWithoutResponse;
          await _writeCharacteristic!.write(
            chunk.codeUnits,
            withoutResponse: useNoResponse,
          );
        }
      }
    } catch (e) {
      print("Error sending data: $e");
    }
  }
}