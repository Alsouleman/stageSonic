import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stagesonic_video/Widgets/BoxShadow_widget.dart';
import 'package:stagesonic_video/screens/goLive_screen/VideoConference.dart';
import 'package:stagesonic_video/screens/login_registration_screen/login_screen.dart';
import 'package:stagesonic_video/screens/schedule_screen/presentation_planner.dart';
import 'package:stagesonic_video/services/camera_widget.dart';
import 'package:stagesonic_video/utils/utils.dart';
import 'Widgets/customNaviDrawer.dart';
import 'Widgets/numbers_widget.dart';
import 'model/User.dart';
import 'model/Video.dart';
import 'screens/watchOther_screen/watch_other_page.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerColor: Colors.black,
      ),
      home: FirebaseAuth.instance.currentUser?.uid != null
          ? const StartScreen()
          : const LoginScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  final currentUser = FirebaseAuth.instance.currentUser;
  final dbRef = FirebaseDatabase.instance.ref();
  Color textColor = Colors.black;
  late AnimationController _animationController;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  final user = FirebaseAuth.instance.currentUser;
  MyUser? userInformation;
  bool _bool = true;
  double buttonsWidth = 150;
  double buttonsHeight = 70;
  Color buttonsColor = Colors.grey[50]!;
  Color shadowColorLeft = Colors.white60;
  Color shadowColorRight = Colors.grey;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? videoFile;
  UploadTask? task;
  double? ranking;
  int? views;
  int? likes;
  int? visitor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));

    _animation1 = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _bool = true;
        }
      });
    _animation2 = Tween<double>(begin: 0, end: .3).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animation3 = Tween<double>(begin: .9, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.ease))
      ..addListener(() {
        setState(() {});
      });
    _getUser();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            color: Colors.black,
          ),
          splashColor: Colors.transparent,
          onPressed: () {
            if (_bool == true) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
            _bool = false;
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Stack(children: [
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Practice Makes Perfect",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 45, top: 5, right: 50),
                  child: CircularPercentIndicator(
                    radius: 80,
                    lineWidth: 12,
                    percent: double.parse(
                        (((ranking ?? 0) / 100) * 10).toStringAsFixed(2)),
                    animation: true,
                    animationDuration: 1800,
                    center: Text(
                      "${double.parse((((ranking ?? 0) / 100) * 100).toStringAsFixed(2))}%",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Ranking",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 35,
                ),
                NumbersWidget(
                  holder1: "Likes",
                  value1: likes,
                  holder2: "Visitor",
                  value2: visitor,
                  holder3: "Views",
                  value3: views,
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        BoxShadowWidget(
                          shadowColorLeft: shadowColorLeft,
                          shadowColorRight: shadowColorRight,
                          height: buttonsHeight,
                          width: buttonsWidth,
                          onClicked: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WatchOtherPage()));
                          },
                          backgroundColor: buttonsColor,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Watch others",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        BoxShadowWidget(
                          shadowColorLeft: shadowColorLeft,
                          shadowColorRight: shadowColorRight,
                          height: buttonsHeight,
                          width: buttonsWidth,
                          onClicked: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PresentationPlanner()));
                          },
                          backgroundColor: buttonsColor,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Schedule",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        BoxShadowWidget(
                          shadowColorLeft: shadowColorLeft,
                          shadowColorRight: shadowColorRight,
                          height: buttonsHeight,
                          width: buttonsWidth,
                          onClicked: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String? title;
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    title: const Text('Enter a title'),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          title = value;
                                        });
                                      },
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: const Text('Submit'),
                                        onPressed: () {
                                          addConferenceFromFirebase(title!);
                                          Navigator.pop(context, title);
                                        },
                                      ),
                                    ],
                                  );
                                });
                              },
                            ).then((value) {
                              if (value != null && value.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoConference(
                                      onLeave: () {
                                        deleteConferenceFromFirebase();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const StartScreen()));
                                      },
                                      username: userInformation?.username,
                                      conferenceID: user!.uid,
                                      title: value,
                                    ),
                                  ),
                                );
                              }
                            });
                          },
                          backgroundColor: buttonsColor,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Go Live",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        BoxShadowWidget(
                          shadowColorLeft: shadowColorLeft,
                          shadowColorRight: shadowColorRight,
                          height: buttonsHeight,
                          width: buttonsWidth,
                          onClicked: _showVideoOptions,
                          backgroundColor: buttonsColor,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                "Try offline",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )), //Buttons
          ],
        ),
        CustomNavigationDrawer(
          userInformation: userInformation,
          showDrawer: _bool,
          animation1: _animation1,
          animation2: _animation2,
          animation3: _animation3,
          width: MediaQuery.of(context).size.width,
        ),
      ]),
    );
  }

  StreamSubscription<DatabaseEvent> _getUser() {
    final ref = FirebaseDatabase.instance.ref().child('users/${user!.uid}');
    return ref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        final MyUser userFromFirebase = MyUser.fromMap(data);

        setState(() {
          userInformation = userFromFirebase;
        });
      }
      _calculateRanking();
    });
  }

  _calculateRanking() {
    int totalViews = 0;
    int totalLikes = 0;
    int totalVisits = 0;
    if (userInformation != null) {
       totalVisits = int.tryParse(userInformation?.visitorCounter ?? '0') ?? 0;

      for (var element in userInformation!.videos) {
        totalViews += int.tryParse(element.viewCount ?? '0') ?? 0;
        totalLikes += int.tryParse(element.likeCount ?? '0') ?? 0;
      }
    }

    double rankingValue = Utils.WEIGHT1 * totalViews +
        Utils.WEIGHT2 * totalLikes +
        Utils.WEIGHT3 * totalVisits;

    setState(() {
      ranking = rankingValue;
      views = totalViews;
      likes = totalLikes;
      visitor = totalVisits;
    });
  }

  void _showVideoOptions() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Upload Video'),
                      onPressed: () async {
                        Navigator.pop(context);
                        var ved =
                            await picker.pickVideo(source: ImageSource.gallery);
                        if (ved != null) {
                          videoFile = File(ved.path);
                          _uploadVideo(_titleController.text,
                              _descriptionController.text, 'thumbnail', '0');
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.camera),
                      label: const Text('Take Video'),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context)  =>    const CameraScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  Future _uploadVideo(
    String title,
    String description,
    String thumbnail,
    String likeCount,
  ) async {
    try {
      if (currentUser != null) {
        final newKey = dbRef.child('data').push().key;
        final vedId = newKey;
        final path = 'videos/$vedId/${currentUser!.uid}';
        final ref = FirebaseStorage.instance.ref().child(path);
        task = ref.putFile(videoFile!);
        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        final Video videoToUpload = Video(
            userId: currentUser!.uid,
            description: description,
            title: title,
            videoUrl: urlDownload,
            thumbnail: thumbnail,
            viewCount: '0',
            date: DateTime.now(),
            subscribeCount: '0',
            likeCount: likeCount,
            unlikeCount: '0');

        dbRef.child('data/$newKey').set(videoToUpload.toJson());
        dbRef
            .child('/users/${currentUser!.uid}/videos/$newKey')
            .set(videoToUpload.toJson());
      }
    } catch (e) {}
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  void deleteConferenceFromFirebase() {
    dbRef.child('conferences').child(user!.uid).remove();
  }

  void addConferenceFromFirebase(String title) {
    dbRef.child('conferences').child(user!.uid).set({
      'title': title,
      'username': userInformation!.username,
      'conferencesID': user!.uid
    });
  }
}
