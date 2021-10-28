class Post {
  int userId;

  Post({
    this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) => new Post(
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
      };
}
