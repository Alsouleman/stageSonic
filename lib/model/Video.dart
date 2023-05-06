import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Video {
   String? id;
   String? name;
   String? url;
   String? description;

   Video ({ this.id, required this.name , required this.url ,  required this.description});

   Map< String, dynamic > toJson ( ) {
     return {
       'name': this.name!,
       'description': this.description == null ? '' : this.description!,
       'url': this.url!,
     };
   }

   factory Video.fromDataSnapshot(DataSnapshot dataSnapshot) {
     Map<String, dynamic> data = Map<String, dynamic>.from(dataSnapshot.value as Map<dynamic, dynamic>);
     return Video(
         id: dataSnapshot.key,
         name: data["name"],
         url: data["url"],
         description: data["description"]
     );
   }

 }
