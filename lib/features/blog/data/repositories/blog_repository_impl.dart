import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

import '../datasources/blog_remote_data_source.dart';

import '../../domain/entities/blog.dart';
import '../../domain/repositories/blog_repository.dart';

import '../models/blog_model.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl({
    required this.blogRemoteDataSource,
  });

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String userId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v4().toString(),
        userId: userId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final String imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image,
        blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      await blogRemoteDataSource.uploadBlog(blogModel);

      return right(blogModel);
    } on ServerException catch (error) {
      return left(Failure(message: error.message));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
