import 'Video.dart';

class MyUser {
  final String? id;
  final String email;
  final String password;
  final String username; // Benutzername für das Profil
  final String profileImageUrl; // URL des Profilbildes
  final List<Video> videos; // Liste der vom Benutzer hochgeladenen Videos

  const MyUser({
    this.id,
    required this.email,
    required this.password,
    required this.username,
    required this.profileImageUrl,
    required this.videos,
  });

  Map<String, dynamic> toJson(){
    return {
      "Email": email,
      "Password": password,
      "Username": username,
      "ProfileImageUrl": profileImageUrl,
      "Videos": videos.map((video) => video.toJson()).toList(),
    };
  }
}
