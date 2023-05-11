import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stagesonic_video/utils/videoPlayer.dart';
import 'package:stagesonic_video/model/Video.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DisplayVideos extends StatefulWidget {
  const DisplayVideos({Key? key}) : super(key: key);

  @override
  State<DisplayVideos> createState() => _DisplayVideosState();
}

class _DisplayVideosState extends State<DisplayVideos>  with TickerProviderStateMixin{
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('data');
  List<Video> videoUrls = [];
  StreamSubscription<DatabaseEvent>? _streamSubscription;
  List<bool> showDescription = []; // Add a list to store description visibility

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await videosData();
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> videosData() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('data');
    _streamSubscription = dbRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value is Map) {
        Map<String, dynamic> videosData = Map<String, dynamic>.from(
            snapshot.value as Map<dynamic, dynamic>);
        List<Video> fetchedVideos = [];

        videosData.forEach((key, value) {
          fetchedVideos.add(Video.fromDataSnapshot(snapshot.child(key)));
        });

        if (mounted) {
          setState(() {
            videoUrls = fetchedVideos;
            showDescription = List<bool>.filled(videoUrls.length, false); // Initialize the showDescription list
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView.builder(
          itemCount: videoUrls.length,
          itemBuilder: (BuildContext c, int i) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: w / 15),
                  height: w,
                  child: getVideoPlayer(videoUrls[i].url!),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        videoUrls[i].name!,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showDescription[i] = !showDescription[i];
                        });
                      },
                      child:  Text(
                        "show more..",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[900],
                        ),
                      ),
                    ),
                  ],
                ),
                showDescription[i]
                    ? Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(videoUrls[i].description!),
                    const SizedBox(height: 10,),
                  ],
                )
                    : const SizedBox(height: 0, width: 0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0, width: 15,),
                    IconButton(
                      onPressed: () {
                        // Implement like functionality
                      },
                      icon: const Icon(Icons.thumb_up),
                    ),
                    const SizedBox(height: 10, width: 100,),
                    IconButton(
                      onPressed: () {
                        // Implement comment functionality
                      },
                      icon: const Icon(Icons.comment),
                    ),
                    const SizedBox(height: 10, width: 90,),
                    IconButton(
                      onPressed: () {
                        // Implement share functionality
                      },
                      icon: const Icon(Icons.share),
                    ),
                  ],
                ),
                const SizedBox(height: 10,)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getVideoPlayer(String url) {
    if (YoutubePlayer.convertUrlToId(url) != null) {
      return YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(url)!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            loop: true,
          ),
        ),
      );
    } else {
      return VideoPlayer(src: url,);
    }
  }
}