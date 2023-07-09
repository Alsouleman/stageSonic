
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:stagesonic_video/Widgets/commentSection_widget.dart';
import 'package:stagesonic_video/model/Comment.dart';
import 'package:stagesonic_video/model/User.dart';
import 'package:stagesonic_video/services/userProvider_widget.dart';
import 'package:stagesonic_video/screens/userProfile/profile_page.dart';
import '../../Widgets/VideoPlayer_widget.dart';
import '../../Widgets/profileImage_widget.dart';
import '../../model/Video.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../login_registration_screen/login_screen.dart';

class WatchOtherPage extends StatefulWidget {
  const WatchOtherPage({super.key});

  @override
  _WatchOtherPageState createState() => _WatchOtherPageState();
}

class _WatchOtherPageState extends State<WatchOtherPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final _commentController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.ref();
  MyUser? user;
  List<Video> videoUrls = [];
  Map<String, bool> likedVideos = {};
  Color likedColor = Colors.red;
  Color unlikedColor = Colors.white12;
  bool isLiked = false;


  @override
  void initState() {
    super.initState();
    isUserSignedIn();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getVideosFromFirebase();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1b1c1e),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return ListView(
      children: [
        Column(
          children: List.generate(videoUrls.length, (index) {
              getUser(videoUrls[index].userId);
              if(user != null) {
                return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width / 1.9,
                        width: MediaQuery.of(context).size.width,
                        child: VideoPlayerWithURL(
                          src: videoUrls[index].videoUrl!,
                          userID: videoUrls[index].userId!,
                          videoID: videoUrls[index].id!,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        children: [
                         Row(children: [ Text(
                           videoUrls[index].title!,
                           style: const TextStyle(
                               color: Colors.white,
                               fontSize: 14,
                               fontWeight: FontWeight.w500,
                               height: 1.3),
                         ),],),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    getVideosFromFirebase();
                                    if (user != null) {
                                      increaseVisitorCounter(videoUrls[index].userId!);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage(user: user!)),
                                      );
                                    }
                                  },
                                  child: ProfileImage(profileImageUrl: user?.profileImageUrl),
                                ),
                              ),
                              SizedBox(
                                width: size.width - 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [

                                        SizedBox(
                                          width: size.width - 150,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "   ${user?.username}",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    height: 1.5),
                                              ),
                                              Text(
                                                "   ${videoUrls[index].viewCount!} views • ${timeago.format(videoUrls[index].date!)} ",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    height: 1.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if ((await hasUserLikedVideo(videoUrls[index].id!)) != true) {
                                    likeVideo(videoUrls[index].id!);
                                  } else {
                                    unlikeVideo(videoUrls[index].id!);
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: likedVideos[videoUrls[index].id!] ==
                                      true
                                      ? likedColor
                                      : unlikedColor,
                                ),
                              ),
                              Text(
                                "${videoUrls[index].likeCount}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    IconButton(
                      icon: const Icon(Icons.add_comment ,color: Colors.white,),
                      onPressed: () {
                        showAddCommentDialog(context,videoUrls[index].id!,user!.username);
                      },
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      height: 30,
                      width: MediaQuery.of(context).size.width/0.8,
                      child:  GestureDetector(
                        onTap: (){ Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>   CommentSection(
                                currentUser: currentUser!,
                                videoID: videoUrls[index].id!,
                                commentController: _commentController)));},
                        child: const Text("Comments"),
                      ),
                    ),
                    //Comment part function
                  ],
                ),
              );
              } else {
                return Container();
              }
          }),
        )
      ],
    );
  }

  Future<bool>getUser(String? userID) async {
    if(userID != null) {
      MyUser? tempUser =  await UserProvider().getUser(userID) ;
      setState(() {
        user = tempUser;
      });
      return true;
    }
  return false;
  }

  Future<void> getVideosFromFirebase() async {
    if (currentUser != null) {
      dbRef.child("data").onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          List<Video> fetchedVideos = [];
          Map data = event.snapshot.value as Map;
          data.forEach((key, value) {
            fetchedVideos.add(Video.fromMap(key, value));
          });
          videoUrls.clear();
          if (mounted) {
            setState(() {
              videoUrls = fetchedVideos;
            });
          }
        }
      });
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void incrementLikeCount(String videoId) {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('data/$videoId');
    dbRef.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map videoData = snapshot.value as Map;
        int currentLikeCount = int.parse(videoData['likeCount']);
        currentLikeCount += 1; // increment the like count

        dbRef.update({
          'likeCount': currentLikeCount.toString(), // update the like count in firebase
        });
      }
    });

    DatabaseReference dbRef2 =
    FirebaseDatabase.instance.ref('users/${currentUser!.uid}/videos/$videoId');
    dbRef2.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map videoData = snapshot.value as Map;
        int currentLikeCount = int.parse(videoData['likeCount']);
        currentLikeCount += 1; // increment the like count

        dbRef2.update({
          'likeCount': currentLikeCount.toString(), // update the like count in firebase
        });
      }
    });

  }

  void desIncrementLikeCount(String videoId) {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('data/$videoId');

    dbRef.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map videoData = snapshot.value as Map;
        int currentLikeCount = int.parse(videoData['likeCount']);
        if (currentLikeCount > 0) currentLikeCount -= 1;

        dbRef.update({
          'likeCount':
              currentLikeCount.toString(), // update the like count in firebase
        });
      }
    });

    DatabaseReference dbRef2 =
    FirebaseDatabase.instance.ref('users/${currentUser!.uid}/videos/$videoId');

    dbRef2.get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map videoData = snapshot.value as Map;
        int currentLikeCount = int.parse(videoData['likeCount']);
        if(currentLikeCount > 0 ) {
          currentLikeCount -= 1; // increment the like count

          dbRef2.update({
            'likeCount': currentLikeCount.toString(), // update the like count in firebase
          });
        }
      }
    });


  }

  Future<bool> hasUserLikedVideo(String videoId) async {
    DatabaseReference dbRef = FirebaseDatabase.instance
        .ref('users/${currentUser!.uid}/likes/$videoId');

    DataSnapshot snapshot = (await dbRef.once()).snapshot;
    if (snapshot.exists) {
      return true;
    } else {
      // If the like record does not exist, the user has not liked the video.
      return false;
    }
  }

  Future<void> unlikeVideo(String videoId) async {
    final dbRef = FirebaseDatabase.instance.ref();

    await dbRef
        .child('users')
        .child(currentUser!.uid)
        .child('likes')
        .child(videoId)
        .remove();
    desIncrementLikeCount(videoId);
    setState(() {
      likedVideos[videoId] = false;
    });
  }

  void likeVideo(String videoId) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref('users/${currentUser!.uid}/likes');
    dbRef.update({
      videoId: true,
    });

    incrementLikeCount(videoId);
    setState(() {
      likedVideos[videoId] = true;
    });
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  void isUserSignedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  Future<int> increaseVisitorCounter(String userID) async {
    int currentCounter = 0;

    if(userID != FirebaseAuth.instance.currentUser!.uid) {
      final counterRef = dbRef.child('users/$userID');
      final snapshot = await counterRef.get();

      if (snapshot.value != null) {
        dynamic value = snapshot.value;
        if (value is int) {
          currentCounter = value;
        } else if (value is String) {
          currentCounter = int.tryParse(value) ?? 0;
        }
      }
      currentCounter += 1;
      dbRef.child('users/$userID/visitorCounter').set(currentCounter.toString());

    }
    return currentCounter;
  }

  void showAddCommentDialog(BuildContext context, String videoID , String userName) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add comment'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(hintText: 'Enter your comment here'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () async {
                await addComment(
                  videoID,
                  userName,
                  commentController.text,
                  currentUser!.uid,
                );
                commentController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> addComment(String videoID,String userName, String commentText, String userID) async {
    Comment newComment = Comment(
      id: userID,
      userName:userName ,
      userID: userID,
      comment: commentText,
      date: DateTime.now(),
    );

    await dbRef
        .child('data')
        .child(videoID)
        .child('comments')
        .update({newComment.id: newComment.toJson()});
  }


}
