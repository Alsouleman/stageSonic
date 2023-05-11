import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String fullName;
  final String email;
  final String password;
   const User({this.id, required this.fullName, required this.email, required this.password});
 toJson(){
   return {"FullName": fullName ,"Email":email,  "Password": password};
 }

}