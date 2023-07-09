class Comment {
  final String id;
  final String userID;
  final String userName;
  final String comment;
  final DateTime date;

  Comment(
      {required this.id,
      required this.userName,
      required this.userID,
      required this.comment,
      required this.date});

  factory Comment.fromMap(Map<dynamic, dynamic> commentData) {
    List<Comment> comments = [];
    commentData.forEach((key, value) {
      Map temp = value as Map;

      comments.add(Comment(
        id: temp['id'],
        userID: temp['userID'],
        userName: temp['userName'] ?? "User",
        comment: temp['comment'],
        date: DateTime.parse(temp['date']),
      ));
    });
    return comments.first;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'userName': userName,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Comment{id: $id, username: $userID, comment: $comment, date: $date}';
  }
}
