import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:stagesonic_video/screen_video.dart';
import 'package:video_player/video_player.dart';
import 'model/Video.dart';
import 'package:chewie/chewie.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final _reference = FirebaseFirestore.instance.collection('files');

  VideoPlayerController? controller;

  Future<List<Video>> _getVideoFromCloud() async {
    final data = await _reference.get();
    final videos = data.docs.map((e) => Video.fromSnapshot(e)).toList();
    return videos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Video>>(
          future: _getVideoFromCloud(),
          builder: (context, reference) {
            if (reference.connectionState == ConnectionState.done) {
              if (reference.hasData) {
                return Swiper(
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ScreenVideo(src: reference.data![index].url!),
                        Positioned(
                          left: 3,

                          bottom: 0.3,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Positioned(
                                  right: 16,
                                  bottom: 16,
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.thumb_up),
                                        onPressed: () {
                                          // Like-Funktionalität hier implementieren
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: () {
                                          // Kommentar-Funktionalität hier implementieren
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  reference.data![index].name!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  reference.data![index].description!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: reference.data!.length,
                  scrollDirection: Axis.vertical,
                );
              } else if (reference.hasError) {
                return Center(child: Text(reference.error.toString()));
              } else {
                return const Center(
                  child: Text("something went wrong"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
