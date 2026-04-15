import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/bin/vmservice_io.dart';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> deltePost(int id);
  Future<Unit> updatePosts(PostModel post);
  Future<Unit> addPost(PostModel post);
}

const baseUrl = "https://dummyjson.com";

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final http.Client client;

  PostsRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> addPost(PostModel post) async {
    final body = {'title': post.title, 'body': post.body};
    final response = await client.post(
      Uri.parse(baseUrl + '/posts/add'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deltePost(int id) async {
    final response = await client.delete(
      Uri.parse(baseUrl + "/posts/${id.toString()}"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(
      Uri.parse(baseUrl + "/posts"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.body);
      List<PostModel> postModels = decodedJson
          .map<PostModel>(
            (jsonPostModelS) => PostModel.fromJson(jsonPostModelS),
          )
          .toList();
      return postModels;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePosts(PostModel post) async {
    final id = post.id.toString();
    final body = {
      'title': post.title,
      'body': post.body,
      'views': post.views,
      'likes': post.likes,
      'dislikes': post.dislikes,
    };
    final response = await client.put(
      Uri.parse(baseUrl + '/posts/${id}'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
