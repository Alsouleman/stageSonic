import 'dart:core';

import 'package:stagesonic_video/model/Comment.dart';

class Video {
  String? id;
  String? userId;
  String? title;
  String? videoUrl;
  String? description;
  String? thumbnail;
  String? viewCount;
  DateTime? date;
  String? subscribeCount;
  String? likeCount;
  String? unlikeCount;
  List<String> likedByUsers;
  List<Comment> comments;

  Video(
      {this.id,
      required this.userId,
      required this.title,
      required this.description,
      required this.videoUrl,
      required this.thumbnail,
      required this.viewCount,
      this.date,
      required this.subscribeCount,
      required this.likeCount,
      required this.unlikeCount,
      this.likedByUsers = const <String>[],
        this.comments = const []
      });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'viewCount': viewCount,
      'date': date?.toIso8601String(),
      'subscribeCount': subscribeCount,
      'likeCount': likeCount,
      'unlikeCount': unlikeCount,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  factory Video.fromMap( String id, Map<dynamic, dynamic> videoData) {
    List<Comment> comments = [];
    if (videoData['comments'] != null) {

     Map temp=  videoData['comments'] as Map;
     temp.forEach((key, value) {comments.add(Comment.fromMap(temp));});}
    return Video(
      id: id,
      title: videoData['title'] ?? '',
      description: videoData['description'] ?? '',
      videoUrl: videoData['videoUrl'] ?? '',
      userId: videoData['userId'] ?? '',
      thumbnail: videoData['thumbnail'] ?? '',
      viewCount: videoData['viewCount'] ?? '',
      date: DateTime.parse(videoData['date'] ?? "1970-01-01 12:00:00.000000"),
      subscribeCount: videoData['subscribeCount'] ?? '',
      likeCount: videoData['likeCount'] ?? '',
      unlikeCount: videoData['unlikeCount'] ?? '',
      likedByUsers: List<String>.from(videoData['likedByUsers'] ?? []),
      comments : comments
    );

  }

  @override
  String toString() {
    return 'Video'
        '{ id: $id, '
           'userId: $userId, '
           'title: $title, '
           'videoUrl: $videoUrl, '
           'description: $description,'
           'thumbnail: $thumbnail, '
           'viewCount: $viewCount, '
           'dayAgo: $date, '
           'subscribeCount: $subscribeCount, '
           'likeCount: $likeCount, '
           'unlikeCount: $unlikeCount }';
  }
}
