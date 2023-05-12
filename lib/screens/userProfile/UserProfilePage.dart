import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../Widgets/VideoPlayerWidget.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;
  UserProfilePage({required this.userId});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(userId)
            .once(),
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.snapshot.value is Map) {
              Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
              List<dynamic> videos = data['videos'] as List<dynamic>? ?? [];
              return ListView(
                children: [

                  Text(data['username'] ?? '', style: const TextStyle(fontSize: 24)),
                  for (var video in videos) ...[
                    VideoPlayerWidget(videoUrl: video),
                    ListTile(
                      title: Text(video['name'] ?? ''),
                      subtitle: Text(video['description'] ?? ''),
                    ),
                  ],
                ],
              );
            } else {
              return Text("Keine Daten"); // Keine Daten gefunden
            }
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Text("Keine Daten"); // Keine Daten gefunden
          }
          return CircularProgressIndicator(); // Ladeanzeige anzeigen, während die Daten geladen werden
        },
      ),
    );
  }
}
