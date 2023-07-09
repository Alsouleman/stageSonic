import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stagesonic_video/Widgets/profile_widget.dart';
import 'package:stagesonic_video/model/User.dart';
import 'package:stagesonic_video/screens/login_registration_screen/login_screen.dart';
import 'dart:ui';
import '../screens/userProfile/profile_page.dart';


class CustomNavigationDrawer extends StatelessWidget {
  final MyUser? userInformation;
  final bool showDrawer;
  final double width;
  final Animation<double> animation1, animation2, animation3;

  CustomNavigationDrawer({super.key,
    this.userInformation,
    required this.showDrawer,
    required this.animation1,
    required this.animation2,
    required this.animation3,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BackdropFilter(
      filter: ImageFilter.blur(
          sigmaY: animation1.value, sigmaX: animation1.value),
      child: Container(
        height: showDrawer ? 0 : height,
        width: showDrawer ? 0 : width,
        color: Colors.transparent,
        child: Center(
          child: Transform.scale(
            scale: animation3.value,
            child: Container(
              width: width * .9,
              height: width * 1.3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(animation2.value),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black12,
                    radius: 35,
                    child: ProfileWidget(
                      profileImage: userInformation?.profileImageUrl ??
                          'https://w0.peakpx.com/wallpaper/979/89/HD-wallpaper-purple-smile-design-eye-smily-profile-pic-face.jpg',
                      onClicked: () async {},
                      isEditable: false,
                    ),
                  ),
                  Column(
                    children: [
                      myTile(Icons.person, 'Profile', () {
                        HapticFeedback.lightImpact();
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProfilePage(user: userInformation!)
                        )
                        );
                      },
                      ),
                      myTile(Icons.settings_outlined, 'Settings', () {
                        HapticFeedback.lightImpact();
                        Fluttertoast.showToast(
                          msg: 'Button pressed',
                        );
                      }),
                      myTile(Icons.info_outline_rounded, 'About', () {
                        HapticFeedback.lightImpact();
                        Fluttertoast.showToast(
                          msg: 'Button pressed',
                        );
                      }),
                    ],
                  ),
                  const SizedBox(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const LoginScreen()));
                        FirebaseAuth.instance.signOut();

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white38,
                      ),
                      child: const Text(
                        "SIGN OUT",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget myTile(
      IconData icon,
      String title,
      VoidCallback voidCallback,
      ) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.black.withOpacity(.08),
          leading: CircleAvatar(
            backgroundColor: Colors.black12,
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
          onTap: voidCallback,
          title: Text(
            title,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1),
          ),
          trailing: const Icon(
            Icons.arrow_right,
            color: Colors.black,
          ),
        ),
        divider()
      ],
    );
  }

  Widget divider() {
    return SizedBox(
      height: 5,
      width: width,
    );
  }
}
