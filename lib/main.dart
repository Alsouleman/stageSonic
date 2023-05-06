import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stagesonic_video/massages/Masseges.dart';
import 'package:stagesonic_video/model/Video.dart';
import 'package:stagesonic_video/screen1.dart';
import 'VideoConference.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

Future <void> main()  async{
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
      home: const MyHomePage(title: 'Flutter Demo Home '),
    routes: const {
   }
    );
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
  final dbRef = FirebaseDatabase.instance.ref().child('data');
  File? videoFile;
  ImagePicker picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/1.jpg'),
            fit: BoxFit.fill,

          )
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                    onPressed: () =>
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Screen1(),
                          ))
                    },
                    child: const Center(
                        widthFactor: 2.85,
                        heightFactor: 2,
                        child: Text("Watch others"))),


                const SizedBox(height: 50,),
                ElevatedButton(
                    onPressed: () =>
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VideoConference(conferenceID: '1')
                          ))
                    },
                    child: const Center(
                        widthFactor: 2.85,
                        heightFactor: 2,
                        child: Text("Go Live"))),
                ElevatedButton(
                    onPressed: (){
                      _uploadVideo("test", "test description");
                    },
                    child: const Center(
                        widthFactor: 3.3,
                        heightFactor: 2,
                        child: Text("add To Real"))),
                ElevatedButton(
                    onPressed: () {

                      },
                    child: const Center(
                        widthFactor: 3.3,
                        heightFactor: 2,
                        child: Text("Take a video"))),
              ],
            ),
          )
      ),
    );
  }

  Future _selectVideo() async {
    var ved = await picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      videoFile = File(ved!.path);
    });
  }

  Future _uploadVideo( String videoName , String description) async {
    _selectVideo();
   try{
     final path = 'videos/${videoFile?.uri.path}';
     print("Vidopath:     ${videoFile?.uri.path}");
     final ref = FirebaseStorage.instance.ref().child(path);
     task = ref.putFile(videoFile!);
     final snapshot = await task!.whenComplete(() {});
     final urlDownload = await snapshot.ref.getDownloadURL();

     final Video videoToVideo = Video(
         name: videoName, url: urlDownload, description: description);
     _reference.add(videoToVideo.toJson());
     dbRef!.push().set(videoToVideo.toJson()).whenComplete(() {

     });
   }
       catch(e){
     _showErrorDialog('${Messages.UPLOAD_FAILED}: $e', 3);
       }

  }


  void _showErrorDialog(String errorMessage, int duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Schließt die Meldung automatisch nach der angegebenen Dauer
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



}
