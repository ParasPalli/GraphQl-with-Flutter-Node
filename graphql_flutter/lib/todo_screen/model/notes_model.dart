class NoteModel {
  String? title;
  bool? completed;
  String? userId;
  UserModel? user;

  NoteModel({
    this.title,
    this.completed,
    this.userId,
    this.user,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      title: json['title'] as String?,
      completed: json['completed'] as bool?,
      userId: json['userId'] as String?,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
      'userId': userId,
      'user': user?.toJson(),
    };
  }
}

class UserModel {
  String? name;

  UserModel({this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
