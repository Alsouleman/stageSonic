import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool isRecording = false;
  String? videoPath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    _initializeControllerFuture = _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<String?> _startVideoRecording() async {
    if (!_controller!.value.isInitialized) {
      return null;
    }

    if (_controller!.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';

    try {
      await _controller!.startVideoRecording();
      videoPath = filePath;
    } on CameraException catch (e) {
      print(e);
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    if (!_controller!.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller!.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 70,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller!);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              left:   MediaQuery.of(context).size.width /3,
              child: Row(
                children: [
                  ElevatedButton(
            onPressed:() async {
                  setState(() {
                    isRecording = !isRecording;
                  });

                  if (isRecording) {
                    await _startVideoRecording();
                  } else {
                    await _stopVideoRecording();
                    print('Video saved to $videoPath');
                  }
            },
            child: const Text("Start",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
          ),
                 const  SizedBox(width: 5,),
                  ElevatedButton(
            onPressed:() async {
                  setState(() {
                    isRecording = !isRecording;
                  });

                  if (!isRecording) {
                    await _stopVideoRecording();
                    print('Video saved to $videoPath');
                  }
            },
            child: const Text("Stop",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
          ),
                ],
              ))
        ],
      ),

    );
  }
}
