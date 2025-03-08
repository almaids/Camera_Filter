import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';
import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(firstCamera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription firstCamera;

  const MyApp({super.key, required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Biodata App',
      theme: ThemeData.light(),
      home: MyHomePage(camera: firstCamera), 
      debugShowCheckedModeBanner: false,
    );
  }
}
