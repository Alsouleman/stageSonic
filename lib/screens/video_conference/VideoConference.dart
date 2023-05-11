import 'dart:math';
import 'package:stagesonic_video/utils/utils.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:flutter/material.dart';

class VideoConference extends StatelessWidget {
  final String conferenceID;

   VideoConference({
    Key? key,
    required this.conferenceID,
  }) : super(key: key);

  final conferenceIdController = TextEditingController();
  final String userId = Random().nextInt(900000 + 100000).toString();
  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: ZegoUIKitPrebuiltVideoConference(
        appID: Utils.appIdVideoConf,
        appSign: Utils.appSignInVideoConf,
        userID: 'user_$userId',
        userName: 'user_name',
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),

    );
  }
}