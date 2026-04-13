import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final int views;
  final int likes;
  final int dislikes;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.views,
    required this.likes,
    required this.dislikes,
  });
  @override
  List<Object?> get props => [id, title, body, views, likes, dislikes];
}
