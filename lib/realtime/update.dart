import 'dart:io';


import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'main3.dart';



class UpdateVideo extends StatefulWidget {
  String videoKey;
  UpdateVideo({super.key, required this.videoKey});

  @override
  State<UpdateVideo> createState() => _UpdateVideoState();
}

class _UpdateVideoState extends State<UpdateVideo> {
  TextEditingController videoName = TextEditingController();
  TextEditingController description = TextEditingController();
  var url;
  var url1;
  File? file;
  ImagePicker image = ImagePicker();
  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('data');
    videos_data();
  }

  void videos_data() async {
    DataSnapshot snapshot = await dbRef!.child(widget.videoKey).get();

    Map videos = snapshot.value as Map;

    setState(() {
      videoName.text = videos['name'];
      description.text = videos['description'];
      url = videos['url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Record'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: url == null
                    ? MaterialButton(
                  height: 100,
                  child: Image.file(
                    file!,
                    fit: BoxFit.fill,
                  ),
                  onPressed: () {
                    getImage();
                  },
                )
                    : MaterialButton(
                  height: 100,
                  child: CircleAvatar(
                    maxRadius: 100,
                    backgroundImage: NetworkImage(
                      url,
                    ),
                  ),
                  onPressed: () {
                    getImage();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: videoName,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Name',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: description,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Number',
              ),
              maxLength: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              height: 40,
              onPressed: () {
                // getImage();

                if (file != null) {
                  uploadFile();
                } else {
                  directupdate();
                }
              },
              child: Text(
                "Update",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              color: Colors.indigo[900],
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      url = null;
      file = File(img!.path);
    });

    // print(file);
  }

  uploadFile() async {
    try {
      var imageFile = FirebaseStorage.instance
          .ref()
          .child("contact_photo")
          .child("/${videoName.text}.jpg");
      UploadTask task = imageFile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url1 = await snapshot.ref.getDownloadURL();
      setState(() {
        url1 = url1;
      });
      if (url1 != null) {
        Map<String, String> Contact = {
          'name': videoName.text,
          'number': description.text,
          'url': url1,
        };

        dbRef!.child(widget.videoKey).update(Contact).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => Home(),
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  directupdate() {
    if (url != null) {
      Map<String, String> Contact = {
        'name': videoName.text,
        'number': description.text,
        'url': url,
      };

      dbRef!.child(widget.videoKey).update(Contact).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Home(),
          ),
        );
      });
    }
  }
}