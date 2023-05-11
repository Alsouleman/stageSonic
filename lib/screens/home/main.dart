import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stagesonic_video/Widgets/BoxShadowWidget.dart';
import 'package:stagesonic_video/model/Video.dart';
import 'package:stagesonic_video/screens/watch_other/displayVideos.dart';
import 'package:stagesonic_video/screens/presentation_planner/presentation_planner.dart';
import '../login/registeration.dart';
import '../video_conference/VideoConference.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../login/login_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
        home:    registeration(),

        //const MyHomePage(title: 'Flutter Demo Home '),
        routes: const {});
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PlatformFile? pickerFile;
  UploadTask? task;

  final _reference = FirebaseFirestore.instance.collection('videos');
  File? videoFile;
  ImagePicker picker = ImagePicker();
  bool okToUpload = false;
  Color iconColor = Colors.white24;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          backgroundColor: Colors.grey[350],
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [

                  const SizedBox(
                    height: 15,
                  ),
                  BoxShadowWidget(
                    height: 75,
                    width: 200,
                    child: TextButton(
                        onPressed: () => {

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DisplayVideos(),
                                  ))
                            },
                        child: const Center(
                            widthFactor: 2.85,
                            heightFactor: 2,
                            child: Text(
                              "Watch others",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BoxShadowWidget(
                    height: 50,
                    width: 300,
                    child: TextButton(
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VideoConference(conferenceID: '1')))
                            },
                        child: const Center(
                            widthFactor: 2.85,
                            heightFactor: 2,
                            child: Text(
                              "Go Live",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BoxShadowWidget(
                    height: 50,
                    width: 300,
                    child: TextButton(
                        onPressed: () {
                          _selectVideo(
                              "Three Minute Thesis winning presentation",
                              "Watch Emily Johnston's Three Minute Thesis UniSA Grand Final winning presentation, 'Mosquito research: saving lives with pantyhose and paperclips'. Emily also won the People's Choice award.");
                        },
                        child: const Center(
                            widthFactor: 2.85,
                            heightFactor: 2,
                            child: Text(
                              "add Video from Gallery",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BoxShadowWidget(
                    height: 50,
                    width: 300,
                    child: TextButton(
                        onPressed: () {},
                        child: const Center(
                            widthFactor: 2.85,
                            heightFactor: 2,
                            child: Text(
                              "Take a video",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BoxShadowWidget(
                    height: 50,
                    width: 300,
                    child: TextButton(
                        onPressed: () => {
                          Get.to(const PresentationPlanner())
                        },
                        child: const Center(
                            widthFactor: 2.85,
                            heightFactor: 2,
                            child: Text(
                              "Go Live",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BoxShadowWidget(
                    height: 50,
                    width: 300,
                    child: TextButton(
                        onPressed: signIn,
                        child: const Center(
                            widthFactor: 2.85,
                            heightFactor: 2,
                            child: Text(
                              "Login....",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ))),
                  ),
                   ],
              ),
            ),
          ),
    );
  }

  Future _selectVideo(String videoName, String description) async {
    var ved = await picker.pickVideo(source: ImageSource.gallery);
    if (ved != null) {
      setState(() {
        videoFile = File(ved!.path);
      });
      _showConfirmationDialog("Möchten Sie das Video hochladen?");
      if (okToUpload) _uploadVideo(videoName, description);
    }
  }

  Future _uploadVideo(String videoName, String description) async {
    try {
      final path = 'videos/$videoName/${videoFile!.path}';
      final ref = FirebaseStorage.instance.ref().child(path);
      task = ref.putFile(videoFile!);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      final Video videoToUpload =
          Video(name: videoName, url: urlDownload, description: description);
      DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('data');
      dbRef.push().set(videoToUpload.toJson());
    } catch (e) {
      _showErrorDialog(': $e', 3);
    }
  }

  void _showErrorDialog(String errorMessage, int duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: duration), () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          title: Text(errorMessage),
          content: Text(errorMessage),
        );
      },
    );
  }

  void _showConfirmationDialog(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bestätigung"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  okToUpload = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  okToUpload = false;
                });
                Navigator.of(context).pop();
                //Get.to(this);
              },
              child: const Text("Abbrechen"),
            ),
          ],
        );
      },
    );
  }

  Color calculateIconColor(Color backgroundColor) {
    // Berechnet die Helligkeit des Hintergrunds
    double brightness = backgroundColor.computeLuminance();

    // Wenn der Hintergrund dunkel ist, geben Sie eine hellere Icon-Farbe zurück, sonst eine dunklere
    if (brightness < 0.5) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Future<void> signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "t@t.com",
        password: "12345678"
    );
  }
}



