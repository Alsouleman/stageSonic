import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:stagesonic_video/temp/SplashRippleEffect.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWithURL extends StatefulWidget {
  final String src;
  final VoidCallback? onError;

  const VideoPlayerWithURL({Key? key, required this.src, this.onError})
      : super(key: key);

  @override
  State<VideoPlayerWithURL> createState() => _VideoPlayerWithURLState();
}

class _VideoPlayerWithURLState extends State<VideoPlayerWithURL> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _controller;

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
      aspectRatio: 16 /9,

    );

    _videoPlayerController!.addListener(() {
      if (_videoPlayerController!.value.hasError) {
        widget.onError?.call();
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

}