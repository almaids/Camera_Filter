import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'displaypicture_screen.dart';
import 'filter_carousel.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({super.key, required this.camera});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            if (!_controller.value.isInitialized) {
              print("Camera is not initialized yet.");
              return;
            }

            final image = await _controller.takePicture();

            if (!context.mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PhotoFilterCarousel(imagePath: image.path),
              ),
            );
          } catch (e) {
            print("Error taking picture: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error taking picture: $e")),
            );
          }
        },
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }
}