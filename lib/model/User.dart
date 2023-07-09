import 'Video.dart';

class MyUser {
  final String? id;
  final String email;
  final String username;
  final String? profileImageUrl;
  final String? about;
  final List<Video> videos;
  final String? visitorCounter;

  const MyUser({
    this.id,
    required this.email,
    required this.username,
    this.profileImageUrl,
    this.about,
    required this.videos,
    this.visitorCounter,
  });

  Map<String, dynamic> toJson() {
    return {
      "Email": email,
      "Username": username,
      "ProfileImageUrl": profileImageUrl,
      "About": about,
      "Videos": videos.map((video) => video.toJson()).toList(),
      "visitorCounter": visitorCounter,
    };
  }

  factory MyUser.fromMap(Map<dynamic, dynamic> userMap) {
    var videosMap = userMap['videos'] != null ? userMap['videos'] as Map : [];
    List<Video> videosList = [];
    if(videosMap is Map){
      videosMap.forEach((key, value) {
        videosList.add(Video.fromMap(key, value));
      });
    }

    return MyUser(
        email: userMap['Email'] ?? '',
        username: userMap['Username'] ?? '',
        profileImageUrl: userMap['ProfileImageUrl'] ??
            'https://w0.peakpx.com/wallpaper/979/89/HD-wallpaper-purple-smile-design-eye-smily-profile-pic-face.jpg',
        about: userMap['about'] ?? '',
        videos: videosList,
        visitorCounter: userMap['visitorCounter'] ?? '0');
  }

  @override
  String toString() {
    return 'MyUser{id: $id, email: $email, username: $username, profileImageUrl: $profileImageUrl, videos: $videos}';
  }
}
