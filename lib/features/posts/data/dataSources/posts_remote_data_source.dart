import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> deltePost(int id);
  Future<Unit> updatePosts(PostModel post);
  Future<Unit> addPost(PostModel post);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource{
  @override
  Future<Unit> addPost(PostModel post) {
    // TODO: implement addPost
    throw UnimplementedError();
  }

  @override
  Future<Unit> deltePost(int id) {
    // TODO: implement deltePost
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getAllPosts() {
    // TODO: implement getAllPosts
    throw UnimplementedError();
  }

  @override
  Future<Unit> updatePosts(PostModel post) {
    // TODO: implement updatePosts
    throw UnimplementedError();
  }
}