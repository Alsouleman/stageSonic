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
import 'package:stagesonic_video/screens/userProfile/UserProfilePage.dart';
import 'package:stagesonic_video/screens/watch_other/displayVideos.dart';
import 'package:stagesonic_video/screens/presentation_planner/presentation_planner.dart';
import '../../temp/home_page.dart';
import '../login/login_screen.dart';
import '../video_conference/VideoConference.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
        home:  const HomePageScreen(),

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance
                            .signOut()
                            .then((value) => Get.to(const LoginScreen()));
                      },
                      icon: const Icon(Icons.logout),
                    ),
                    IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance
                            .signOut()
                            .then((value) => 
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const LoginScreen())
                        )
                        );
                      },
                      icon: const Icon(Icons.new_releases_sharp),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    IconButton(
                      onPressed: () async {
                        var userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null) {
                          Get.to(const UserProfilePage());
                        } else {

                        }
                      },
                      icon: const Icon(Icons.person),
                    ),

                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                BoxShadowWidget(
                  height: 75,
                  width: 200,
                  child: TextButton(
                      onPressed: () =>
                      {
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
                      onPressed: () =>
                      {
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
                            "Watch Emily Johnston's Three Minute Thesis UniSA Grand Final winning presentation, 'Mosquito research: saving lives with pantyhose and paperclips'. Emily also won the People's Choice award.",
                            "",
                            "25",
                            "10",
                            "30",
                            "10",
                            "5"
                        );
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
                      onPressed: () => {Get.to(const PresentationPlanner())},
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

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _selectVideo(String videoName,
      String description,
      String thumbnail,
      String viewCount,
      String dayAgo,
      String subscribeCount,
      String likeCount,
      String unlikeCount) async {
    var ved = await picker.pickVideo(source: ImageSource.gallery);
    if (ved != null) {
      setState(() {
        videoFile = File(ved!.path);
      });

      if (okToUpload) {

      };
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

    String idGenerator() {
      final now = DateTime.now();
      return now.microsecondsSinceEpoch.toString();
    }
  }
}