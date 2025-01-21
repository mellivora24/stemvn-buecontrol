// button_controller.dart

import 'package:flutter/material.dart';
import 'package:stemvn_bluecontrol/bluetooth/ble_manager.dart';

class ButtonController {
  ButtonController(this.context);

  final BuildContext context;
  final BleManager _bleManager = BleManager();

  Future<bool> onButtonPressed(String buttonId, {bool? state}) async {
    switch (buttonId) {
      case "CONNECT":
        if (state == true) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Connect to Device"),
                content: const Text("Please disconnect from the current device before connecting to a new one."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
          return state!;
        } else {
          String isConnected = await _showConnectDialog();
          if (isConnected == "SUCCESS") return true;
          return state ?? false;
        }
      case "DISCONNECT":
        if (state == false) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Disconnect Device"),
                content: const Text("You are not connected to any device."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
          return state!;
        } else {
          String isConnected = await _showDisconnectNotification();
          if (isConnected == "SUCCESS") return false;
          return state ?? false;
        }
      default:
        sendCommand(buttonId);
        break;
    }
    return false;
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
                          if (isConnected) {
                            Navigator.of(context).pop("SUCCESS");
                          } else {
                            Navigator.of(context).pop("ERROR");
                          }
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
          content: const Text("Are you want to disconnect from the device?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop("CANCEL"),
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () async {
                bool isDisconnected = await _bleManager.disconnect();
                if (isDisconnected) {
                  Navigator.of(context).pop("SUCCESS");
                } else {
                  Navigator.of(context).pop("ERROR");
                }
              },
              child: const Text("DISCONNECT"),
            ),
          ],
        );
      },
    ) ?? "CANCEL";
  }

  void sendCommand(String command) {
    _bleManager.sendData(command);
  }
}
