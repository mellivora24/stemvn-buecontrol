import 'package:flutter/material.dart';
import 'package:stemvn_bluecontrol/bluetooth/ble_manager.dart';

class ButtonController {
  ButtonController(this.context);

  final BuildContext context;
  final BleManager _bleManager = BleManager();

  Future<bool> onButtonPressed(String buttonId, {bool?state}) async {
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
          else return state!;
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
          else return state!;
        }

      default:
        print(buttonId);
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
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error scanning devices"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No devices found"));
              } else {
                List<Map<String, String>> devices = snapshot.data!;
                return SizedBox(
                  height: 300,
                  width: 200,
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return ListTile(
                        title: Text(device["name"]!),
                        subtitle: Text(device["address"]!),
                        onTap: () {
                          Navigator.of(context).pop("SUCCESS");
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
          content: const Text("Are you sure you want to disconnect from the device?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop("CANCEL"),
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop("SUCCESS"),
              child: const Text("DISCONNECT"),
            ),
          ],
        );
      },
    ) ?? "CANCEL";
  }
}
