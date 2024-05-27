import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/connection_checker.dart';

import '../datasources/blog_local_data_source.dart';
import '../datasources/blog_remote_data_source.dart';

import '../../domain/entities/blog.dart';
import '../../domain/repositories/blog_repository.dart';

import '../models/blog_model.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl({
    required this.blogRemoteDataSource,
    required this.blogLocalDataSource,
    required this.connectionChecker,
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
      if (!(await connectionChecker.hasConnection)) {
        return left(Failure(message: 'No internet connection!'));
      }

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

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!(await connectionChecker.hasConnection)) {
        final blogs = blogLocalDataSource.loadBlogs();

        return right(blogs);
      }

      final blogs = await blogRemoteDataSource.getAllBlogs();

      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);

      return right(blogs);
    } on ServerException catch (error) {
      return left(Failure(message: error.message));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
