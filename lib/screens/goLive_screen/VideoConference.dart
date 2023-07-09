import 'dart:math';
import 'package:stagesonic_video/utils/utils.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:flutter/material.dart';

class VideoConference extends StatelessWidget {
  final String conferenceID;
  final String? username;
  final String title;
  final Function()? onLeave;
  VideoConference({
    Key? key,
    required this.conferenceID,
    required this.title,
    this.onLeave, this.username,
  }) : super(key: key);

  final conferenceIdController = TextEditingController();
  final String userId = Random().nextInt(900000 + 100000).toString();
  ZegoUIKitPrebuiltVideoConferenceController? controller = ZegoUIKitPrebuiltVideoConferenceController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: Utils.appIdVideoConf,
        appSign: Utils.appSignInVideoConf,
        userID:  userId,
        userName: username ?? 'host',
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          onLeave: onLeave,
          leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(),
          topMenuBarConfig: ZegoTopMenuBarConfig(
            title: title,
              buttons: const [ZegoMenuBarButtonName.showMemberListButton],
          ),
          bottomMenuBarConfig: ZegoBottomMenuBarConfig(
            buttons: const [
              ZegoMenuBarButtonName.chatButton,
              ZegoMenuBarButtonName.leaveButton,
              ZegoMenuBarButtonName.switchAudioOutputButton,
              ZegoMenuBarButtonName.toggleMicrophoneButton
            ],
          ),
        ),
      ),
    );
  }
}
