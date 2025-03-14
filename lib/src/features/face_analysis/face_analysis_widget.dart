import 'package:flutter/material.dart';
import 'package:face_verify/face_verify.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FaceAnalysisDialog extends StatelessWidget {
  const FaceAnalysisDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Face Analysis'),
      content: const Text('Press Button to start the process.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            WidgetsFlutterBinding.ensureInitialized();
            final cameras = await availableCameras();
            final cameraDescription = cameras.elementAt(1);

            final String user1ImagePath =
                await copyAssetToFile('assets/images/user1.jpg');
            print(user1ImagePath);
            final List<UserModel> users = await registerUsers(
              registerUserInputs: [
                RegisterUserInputModel(
                    name: 'User1', imagePath: user1ImagePath),
                // RegisterUserInputModel(
                //     name: 'User2', imagePath: 'path/to/image2.jpg'),
              ],
              cameraDescription: cameraDescription,
            );            
            Set<UserModel>? recognizedUsers = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetectionView(
                    users: users,
                    cameraDescription: cameraDescription,
                    // frameSkipCount: 10,
                  ),
                ));
            if (recognizedUsers != null && recognizedUsers.isNotEmpty) {
              print('recognized users : $recognizedUsers');
            }
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Analysis Done $cameraDescription')));
          },
          child: const Text('Mulai'),
        ),
      ],
    );
  }

  Future<String> copyAssetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final buffer = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${path.basename(assetPath)}');

    await file.writeAsBytes(buffer);
    return file.path;
  }
}
