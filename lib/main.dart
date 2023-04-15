import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  final _reference = FirebaseFirestore.instance.collection('files');
  File? file;
  ImagePicker picker = ImagePicker();
  var url;
  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('data');
  }

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
                      _selectFile();
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

  Future _selectFile() async {
    var img = await picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  Future _uploadVideo( String videoName , String description) async {
    final path = 'files/videos/${file?.uri.path}';
    final ref = FirebaseStorage.instance.ref().child(path);
    task = ref.putFile(file!);
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);
    final Video videoToVideo = Video(
        name: videoName, url: urlDownload, description: description);
    _reference.add(videoToVideo.toJson());
    dbRef!.push().set(videoToVideo.toJson()).whenComplete(() {

    });
  }


}
