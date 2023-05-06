import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:stagesonic_video/model/Video.dart';
import 'package:stagesonic_video/screen_video.dart';


class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('data');
  TextEditingController videoName = TextEditingController();
  TextEditingController description = TextEditingController();
  List<Video> videoUrls = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await videosData();
    });
  }

  Future<void> videosData() async {
    dbRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value is Map) {
        Map<String, dynamic> videosData = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
        List<Video> fetchedVideos = [];

        videosData.forEach((key, value) {
          fetchedVideos.add(Video.fromDataSnapshot(snapshot.child(key)));
        });

        setState(() {
          videoUrls = fetchedVideos;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: videoUrls.isNotEmpty
            ? Swiper(
          itemBuilder: (BuildContext context, int index) {
            return ScreenVideo (src :videoUrls[index].url!);

          },
          itemCount: videoUrls.length,
          pagination: const SwiperPagination(),
          control: const SwiperControl(),
        )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
