class NewsModel {
  List<News> news;

  NewsModel({this.news});

  NewsModel.fromJson(Map<String, dynamic> json) {
    if (json['news'] != null) {
      news = List<News>();
      json['news'].forEach((v) {
        news.add(News.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.news != null) {
      data['news'] = this.news.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class News {
  User user;
  Message message;

  News({this.user, this.message});

  News.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    return data;
  }
}

class User {
  String name;
  String profilePicture;

  User({this.name, this.profilePicture});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_picture'] = this.profilePicture;
    return data;
  }
}

class Message {
  String content;
  String createdAt;

  Message({this.content, this.createdAt});

  Message.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    return data;
  }
}
