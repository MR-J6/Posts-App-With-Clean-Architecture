import 'package:dartz/dartz.dart';
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/network_info.dart';
import 'package:posts_app/features/posts/data/dataSources/posts_local_data_source.dart';
import 'package:posts_app/features/posts/data/dataSources/posts_remote_data_source.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';

typedef Future<Unit> DeleteOrUpdateOrAddPost();

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final postsRemote = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(postsRemote);
        return Right(postsRemote);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final postLocal = await localDataSource.getCachedPosts();
        return Right(postLocal);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel = PostModel(
      id: post.id,
      title: post.title,
      body: post.body,
      views: post.views,
      likes: post.likes,
      dislikes: post.dislikes,
    );

    return await getMessage(() => remoteDataSource.addPost(postModel));
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async {
    return await getMessage(() => remoteDataSource.deltePost(id));
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel = PostModel(
      id: post.id,
      title: post.title,
      body: post.body,
      views: post.views,
      likes: post.likes,
      dislikes: post.dislikes,
    );

    return await getMessage(() => remoteDataSource.updatePosts(postModel));
  }

  Future<Either<Failure, Unit>> getMessage(DeleteOrUpdateOrAddPost f) async {
    if (await networkInfo.isConnected) {
      try {
        await f();
        return right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
