import 'package:flutter/material.dart';
import 'package:flutter_app/src/app.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  print('1 -' + cameras.length.toString());
  runApp(new MyApp());
}


