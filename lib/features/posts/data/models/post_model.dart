import 'package:posts_app/features/posts/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.views,
    required super.likes,
    required super.dislikes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json){
    return PostModel(
      id: json['id'], 
      title: json['title'], 
      body: json['body'], 
      views: json['views'], 
      likes: json['reactions']['likes'], 
      dislikes: json['reactions']['dislikes']);
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'body': body,
      'views': views,
      'reactions': {
        'likes': likes,
        'dislikes': dislikes
      }
    };
  }
}
