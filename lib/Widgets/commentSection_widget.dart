import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:stagesonic_video/Widgets/BoxShadow_widget.dart';

import 'package:stagesonic_video/model/Comment.dart';
import '../model/User.dart';


class CommentSection extends StatefulWidget {
  final User currentUser;
  final String videoID;
  final TextEditingController commentController;

  const CommentSection({
    Key? key,
    required this.currentUser,
    required this.videoID,
    required this.commentController,
  }) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  MyUser? user;
  bool isValidUser = false;
  final dbRef = FirebaseDatabase.instance.ref();
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:  Container(
        margin: const EdgeInsets.only(top: 100),
        child: FirebaseAnimatedList(
            query: FirebaseDatabase.instance.ref().child('data/${widget.videoID}/comments'),
            itemBuilder: (ctx, snapshot, animation, index) {
              if(snapshot.exists) {
                return Card(
                  color: Colors.white70,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${snapshot.child('userName').value ?? "User"}:",style: const TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.child('comment').value}"),
                        const SizedBox(height: 5,)
                      ],
                    ),
                  ),
                );
              } else {
                return Placeholder();
              }

            }
        ),
      )



        ,);

  }







}
