import 'package:flutter/material.dart';
import 'package:face_verify/face_verify.dart';
import 'package:camera/camera.dart';

class FaceAnalysisDialog extends StatelessWidget {
  const FaceAnalysisDialog({Key? key}) : super(key: key);
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
            WidgetsFlutterBinding.ensureInitialized();
            final cameras = await availableCameras();
            final cameraDescription = cameras.first;
            final List<UserModel> users = await registerUsers(
              registerUserInputs: [
                RegisterUserInputModel(
                    name: 'User1', imagePath: 'path/to/image1.jpg'),
                RegisterUserInputModel(
                    name: 'User2', imagePath: 'path/to/image2.jpg'),
              ],
              cameraDescription: cameraDescription,
            );
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Analysis Done $cameraDescription')));
          },
          child: const Text('Mulai'),
        ),
      ],
    );
  }
}
