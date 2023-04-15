import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ScreenVideo extends StatefulWidget {
  final String src;
  final VoidCallback? onError;

  const ScreenVideo({Key? key, required this.src, this.onError})
      : super(key: key);

  @override
  State<ScreenVideo> createState() => _ScreenVideoState();
}

class _ScreenVideoState extends State<ScreenVideo> {
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
      autoPlay: true,
      showControls: false,
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
    _videoPlayerController!.dispose();
    _controller!.dispose() ;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _controller != null && _controller!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _controller!)
            : const SizedBox(),
      ],
    );
  }
}
