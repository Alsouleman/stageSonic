import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stagesonic_video/model/User.dart';
import '../Widgets/VideoPlayer_widget.dart';
import '../Widgets/profile_widget.dart';
import '../model/Video.dart';


class ProfilePage extends StatefulWidget {
  final MyUser user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  ImagePicker picker = ImagePicker();
  File? videoFile;
  File? imageFile;
  UploadTask? task;
  int visitorCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            profileImage: widget.user.profileImageUrl ??
                'https://w0.peakpx.com/wallpaper/979/89/HD-wallpaper-purple-smile-design-eye-smily-profile-pic-face.jpg',
            onClicked: ()  async {
              var ved = await picker.pickImage(source: ImageSource.gallery);
              if (ved != null) {
                setState(() {
                  imageFile = File(ved!.path);
                });
                _uploadProfileImage();

            } },
            isEditable: true,
          ),
          const SizedBox(
            height: 24,
          ),
          buildName(widget.user),
          const SizedBox(
            height: 24,
          ),
         //TODO....User Status
          const SizedBox(
            height: 24,
          ),
          Container(
            height: 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[400],
          ),
          Column(
            children: List.generate(widget.user.videos.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Colors.red,
                          height: MediaQuery.of(context).size.width / 1.78,
                          width: MediaQuery.of(context).size.width,
                          child: VideoPlayerWithURL(
                            src: widget.user.videos[index].videoUrl!,
                            videoID: widget.user.videos[index].id!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,)
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildName(MyUser user) => Column(
        children: [
          Text(
            user.username,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user.about!,
            style: const TextStyle(
              color: Colors.purple,
            ),
          ),
        ],
      );

  Widget buildAbout(MyUser user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              user.about!,
              style: const TextStyle(
                  fontSize: 16, height: 1.4, color: Colors.black),
            ),
          ],
        ),
      );

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }
  Future _selectVideo(
      String videoName,
      String description,
      String thumbnail,
      String likeCount,
      ) async {
    var ved = await picker.pickVideo(source: ImageSource.gallery);
    if (ved != null) {
      setState(() {
        videoFile = File(ved!.path);
      });
      _uploadVideo(videoName, description, thumbnail, likeCount);
    }
  }

  Future _uploadVideo(
      String title,
      String description,
      String thumbnail,
      String likeCount,
      ) async {
    try {
      if (currentUser != null) {
        final vedId = idGenerator();
        final path = 'videos/$vedId/${currentUser!.uid}';
        final ref = FirebaseStorage.instance.ref().child(path);
        task = ref.putFile(videoFile!);
        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        final Video videoToUpload = Video(
            userId: currentUser!.uid,
            description: description,
            title: title,
            videoUrl: urlDownload,
            thumbnail: thumbnail,
            viewCount: '0',
            date: DateTime.now(),
            subscribeCount: '0',
            likeCount: likeCount,
            unlikeCount: '0');

        dbRef.child('data').push().set(videoToUpload.toJson());

        dbRef.child('/users/${currentUser!.uid}/videos').update({
          vedId: videoToUpload.toJson(),
        });
      }
    } catch (e) {

    }
  }

  Future _uploadProfileImage() async {
    try {
      if (currentUser != null) {
        final path = 'images/profileImages/${currentUser!.uid}';
        final ref = FirebaseStorage.instance.ref().child(path);
        task = ref.putFile(imageFile!);
        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        dbRef.child('users/${currentUser!.uid}/ProfileImageUrl').set(urlDownload);
      }
    } catch (e) {
    }
  }



}
