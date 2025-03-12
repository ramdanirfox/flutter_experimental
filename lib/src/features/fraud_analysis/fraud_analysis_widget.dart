import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
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
