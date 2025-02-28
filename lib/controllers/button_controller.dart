import 'package:flutter/material.dart';
import 'package:stemvn_bluecontrol/bluetooth/ble_manager.dart';

class ButtonController {
  final BuildContext context;
  final BleManager _bleManager; // Nhận từ ngoài

  ButtonController(this.context, this._bleManager); // Thêm tham số BleManager

  Future<bool> onButtonPressed(String buttonId, {bool? state}) async {
    switch (buttonId) {
      case "CONNECT":
        if (state == true) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Connect to Device"),
              content: const Text("Please disconnect from the current device first."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
          return state!;
        } else {
          String result = await _showConnectDialog();
          return result == "SUCCESS";
        }
      case "DISCONNECT":
        if (state == false) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Disconnect Device"),
              content: const Text("You are not connected to any device."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
          return state!;
        } else {
          String result = await _showDisconnectNotification();
          return result != "SUCCESS"; // Trả về false nếu ngắt kết nối thành công
        }
      default:
        sendCommand(buttonId);
        return state ?? false;
    }
  }

  Future<String> _showConnectDialog() async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Connect to Device"),
          content: FutureBuilder<List<Map<String, String>>>(
            future: _bleManager.scanDevices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error scanning devices"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No devices found"));
              } else {
                List<Map<String, String>> devices = snapshot.data!;
                return SizedBox(
                  height: 300,
                  width: 200,
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final deviceInfo = devices[index];
                      return ListTile(
                        title: Text(deviceInfo["name"]!),
                        subtitle: Text(deviceInfo["address"]!),
                        onTap: () async {
                          bool isConnected = await _bleManager.connect(deviceInfo["address"]!);
                          Navigator.of(context).pop(isConnected ? "SUCCESS" : "ERROR");
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop("CANCEL"),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    ) ?? "CANCEL";
  }

  Future<String> _showDisconnectNotification() async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Disconnect Device"),
          content: const Text("Are you sure you want to disconnect?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop("CANCEL"),
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                bool isDisconnected = await _bleManager.disconnect();
                Navigator.of(context).pop(isDisconnected ? "SUCCESS" : "ERROR");
              },
              child: const Text("DISCONNECT"),
            ),
          ],
        );
      },
    ) ?? "CANCEL";
  }

  void sendCommand(String command) {
    print("ButtonController sending: $command"); // Debug
    _bleManager.sendData(command);
  }
}