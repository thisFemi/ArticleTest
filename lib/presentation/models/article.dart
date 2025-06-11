class Article {
  final int id;
  final int userId;
  final String title;
  final String body;

  Article({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']??0,
      userId: json['userId']??0,
      title: json['title']??"",
      body: json['body']??"",
    );
  }
    String get snippet => body.length > 50 ? '${body.substring(0, 50)}...' : body;
}



class Comment {
  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  Comment({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']??0,
      postId: json['postId']??0,
      name: json['name']??"",
      email: json['email']??"",
      body: json['body']??'',
    );
  }
}