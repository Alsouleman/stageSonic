
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String profileImage;
  final VoidCallback onClicked;
  final bool isEditable;
  const ProfileWidget(
      {Key? key,
      required this.profileImage,
      required this.onClicked,
      required this.isEditable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Stack(children: [
        buildImage(),
        isEditable ?
        Positioned(
          bottom: 0,
          right: 4,
          child: buildEditIcon(Colors.blue),
        ) :
        const SizedBox(height: 0,width: 0,),
      ]),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(profileImage);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,

        ),
      ),
    );
  }

  Widget buildEditIcon(Color iconColor) => buildCircle(
      color: Colors.white,
      all: 1,
      child: buildCircle(
          color: iconColor,
          all: 0,
          child: IconButton(
              onPressed: onClicked,
              icon: const Icon(
                color: Colors.white,
                Icons.edit,
                size: 20,
              ),
          ),
      ));

  Widget buildCircle({required color, required double all, required Widget child}) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
