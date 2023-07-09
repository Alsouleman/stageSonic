import 'package:chewie/chewie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stagesonic_video/Widgets/SplashRippleEffect.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWithURL extends StatefulWidget {
  final String src;
  final String videoID;
  final String userID;
  final VoidCallback? onError;

  const VideoPlayerWithURL({Key? key, required this.src, required this.userID , this.onError, required this.videoID})
      : super(key: key);

  @override
  State<VideoPlayerWithURL> createState() => _VideoPlayerWithURLState();
}

class _VideoPlayerWithURLState extends State<VideoPlayerWithURL> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _controller;
  final dbRef = FirebaseDatabase.instance.ref();
  bool hasIncreasedViewCounter = false;



  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    _videoPlayerController = VideoPlayerController.network(widget.src);
    await Future.wait([_videoPlayerController!.initialize()]);
    _controller = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 /10,
        showOptions: false,
    );

    _videoPlayerController!.addListener(() {
      if (_videoPlayerController!.value.hasError) {
        widget.onError?.call();
      }
      if (_videoPlayerController!.value.isPlaying && !hasIncreasedViewCounter) {
        increaseViewCounter();
        hasIncreasedViewCounter = true; // Add this line
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _controller != null && _controller!.videoPlayerController.value.isInitialized
            ? Container(

          color: Colors.black,
          child: Chewie(controller: _controller!),
        )
            : const SplashRippleEffect(),
      ],
    );
  }

  Future<void> increaseViewCounter() async {
    final counterRef = dbRef.child('data/${widget.videoID}/viewCount');
    final counterRefUser = dbRef.child('users/${widget.userID}/videos/${widget.videoID}/viewCount');
    final snapshot = await counterRef.get();
    final snapshotUser = await counterRefUser.get();
    int currentCounter = 0;
    int currentCounterUser = 0;
    if (snapshot.value != null && snapshotUser.value != null ) {
      dynamic value = snapshot.value;
      dynamic valueUser = snapshotUser.value;
      if (value is int) {
        currentCounter = value;
      } else if (value is String) {
        currentCounter = int.tryParse(value) ?? 0;
      }
      if (valueUser is int) {
        currentCounterUser = value;
      } else if (valueUser is String) {
        currentCounterUser = int.tryParse(valueUser) ?? 0;
      }
    }
    currentCounter += 1;
    currentCounterUser += 1;
    dbRef.child('data/${widget.videoID}/viewCount').set(currentCounter.toString());
    counterRefUser.set(currentCounterUser.toString());
  }




}