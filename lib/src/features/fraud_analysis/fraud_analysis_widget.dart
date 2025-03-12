import 'dart:io';

import 'package:biometric_signature/biometric_signature.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:security_plus/security_plus.dart';
import 'package:vpn_connection_detector/vpn_connection_detector.dart';

class FraudDialog extends StatelessWidget {
  const FraudDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Fraud Analysis'),
      content: const Text('Press Button to start the process.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Analysis started!')),
            );
            List<AppInfo> apps = await InstalledApps.getInstalledApps();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Installed Apps'),
                  content: Container(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: apps.length,
                      itemBuilder: (BuildContext context, int index) {
                        AppInfo app = apps[index];
                        return ListTile(
                          // leading: Image.memory(app.icon),
                          //                         app.icon != null
                          // ? Image.memory(app.icon)
                          // : Image.asset('default_icon.png'), // or some other default image

                          // leading: Image.memory(app.icon!),
                          // leading: Image.memory(app.icon ?? Uint8List(0)),
                          leading: Text("app"),
                          title: Text(app.name),
                          subtitle: Text(app.packageName),
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Analysis Done! Apps = ${apps.length}')),
            );
          },
          child: const Text('Apps'),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Analyzing VPN')),
            );
            final stream = VpnConnectionDetector();
            VpnConnectionDetector.isVpnActive().then((value) {
              // print(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('VPN Status = $value ')),
              );
            });
          },
          child: const Text('Jail'),
        ),
        TextButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Analyzing Jailbreak Status')),
            );
            var _issues = '';
            final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
            final isRealDevice =
                await JailbreakRootDetection.instance.isRealDevice;

            final checkForIssues =
                await JailbreakRootDetection.instance.checkForIssues;
            for (final issue in checkForIssues) {
              _issues += '${issue.name}, \n';
            }

            if (Platform.isAndroid) {
              try {
                bool isOnExternalStorage =
                    await JailbreakRootDetection.instance.isOnExternalStorage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Android, ExtStorage = $isOnExternalStorage, notTrust = $isNotTrust, realDevice = $isRealDevice, issues = $_issues')),
                );
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            }

            if (Platform.isIOS) {
              // const bundleId = 'com.w3conext.jailbreakRootDetectionExample';
              const bundleId = 'com.example.flutter_experimental';
              final isTampered =
                  await JailbreakRootDetection.instance.isTampered(bundleId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Android, tamper = $isTampered, notTrust = $isNotTrust, realDevice = $isRealDevice, issues = $_issues')),
              );
            }
          },
          child: const Text('Tamper'),
        ),
        TextButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Analyzing Mock Location')),
            );
            if (Platform.isAndroid) {
              final status = await Permission.location.request();
              if (!status.isGranted) {
                // Handle permission denied
                return;
              }
            }
            try {
              bool isMockLocation = await SecurityPlus.isMockLocationEnabled;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Is Mock Location = $isMockLocation')),
              );
              if (isMockLocation) {
                // Handle mock location
              }
            } catch (e) {
              // Handle errors
            }
          },
          child: const Text('MockLoc'),
        ),
        TextButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Analyzing Platform')),
            );
            final deviceInfoPlugin = DeviceInfoPlugin();
            final deviceInfo = await deviceInfoPlugin.deviceInfo;
            final allInfo = deviceInfo.data;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Details = ${allInfo.toString()}')),
            );
          },
          child: const Text('Platform'),
        ),
        TextButton(
          // Please update MainActivity.kt as follows
          // import io.flutter.embedding.android.FlutterFragmentActivity
          // class MainActivity: FlutterFragmentActivity()
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Checking Biometrics A')),
            );
            final biometricSignature = BiometricSignature();
            final biometrics =
                await biometricSignature.biometricAuthAvailable();
            if (!biometrics!.contains("none, ")) {
              try {
                final String? publicKey = await biometricSignature.createKeys();
                final String? signature = await biometricSignature
                    .createSignature(options: {
                  "payload": "Payload to sign B",
                  "promptMessage": "You are Welcome C !"
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Auth Done. methods = $biometrics, sig = $signature, pubKey = $publicKey')),
                );
              } on PlatformException catch (e) {
                debugPrint(e.message);
                debugPrint(e.code);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Auth Failed. methods = $biometrics, msg = ${e.message}')),
                );
              }
            }
          },
          child: const Text('Bio'),
        ),
        TextButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Analyzing Location')),
            );
            loc.Location location = new loc.Location();
            bool _serviceEnabled;
            loc.PermissionStatus _permissionGranted;
            loc.LocationData _locationData;

            _serviceEnabled = await location.serviceEnabled();
            if (!_serviceEnabled) {
              _serviceEnabled = await location.requestService();
              if (!_serviceEnabled) {
                return;
              }
            }

            _permissionGranted = await location.hasPermission();
            if (_permissionGranted == PermissionStatus.denied) {
              _permissionGranted = await location.requestPermission();
              if (_permissionGranted != PermissionStatus.granted) {
                return;
              }
            }

            _locationData = await location.getLocation();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Located!\nLng = ${_locationData.longitude}\nLat = ${_locationData.latitude}\nAcc = ${_locationData.accuracy}\nHead = ${_locationData.heading}\nHeadAcc = ${_locationData.headingAccuracy}\n mock = ${_locationData.isMock}')),
            );
          },
          child: const Text('Loc'),
        ),
      ],
    );
  }

  // Future<List<bool>> initPlatformState() async {
  //   bool jailbroken;
  //   bool developerMode;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
  //     final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
  //   } on PlatformException {
  //     jailbroken = true;
  //     developerMode = true;
  //   }
  //   return [jailbroken, developerMode];
  // }
}
