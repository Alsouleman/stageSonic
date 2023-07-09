import 'package:firebase_database/firebase_database.dart';
import 'package:stagesonic_video/model/User.dart';
class UserProvider {
  final dbRef = FirebaseDatabase.instance.ref();

  Future<MyUser?> getUser(String userId) async {
    MyUser? user;
      final snapshot = await dbRef.child('users/$userId').get();
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        MyUser user = MyUser.fromMap(data);
        return user;
      }

    return user;
  }
}
