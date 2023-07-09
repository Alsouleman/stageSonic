import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  String? profileImageUrl;
   ProfileImage( {Key? key , this.profileImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: NetworkImage(
            profileImageUrl ??
                'https://w0.peakpx.com/wallpaper/979/89/HD-wallpaper-purple-smile-design-eye-smily-profile-pic-face.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
