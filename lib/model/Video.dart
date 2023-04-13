import 'dart:core';


import 'package:cloud_firestore/cloud_firestore.dart';

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

   factory Video.fromSnapshot(DocumentSnapshot < Map<String , dynamic>> documentSnapshot){
     final data = documentSnapshot.data()!;
     return Video(
         id: documentSnapshot.id ,
         name: data["name"],
         url: data["url"],
         description: data["description"]
     );
   }
 }
