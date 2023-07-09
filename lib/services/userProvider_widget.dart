import 'package:firebase_database/firebase_database.dart';
import 'package:stagesonic_video/model/User.dart';
class UserProvider {
  final dbRef = FirebaseDatabase.instance.ref();
  Map<String, MyUser> userCache = {};

  Future<MyUser?> getUser(String userId) async {
    if (userCache.containsKey(userId)) {
      return userCache[userId];
    } else {
      final snapshot = await dbRef.child('users/$userId').get();
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        MyUser user = MyUser.fromMap(data);
        userCache[userId] = user;
        return user;
      }
    }
    return null;
  }
}
