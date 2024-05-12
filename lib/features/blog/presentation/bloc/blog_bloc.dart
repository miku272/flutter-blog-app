import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/blog.dart';
import '../../domain/usecases/upload_blog.dart';
import '../../domain/usecases/get_all_blogs.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));

    on<BlogUpload>((event, emit) async {
      final res = await _uploadBlog(UploadBlogParams(
        userId: event.userId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ));

      res.fold(
        (l) => emit(BlogFailure(error: l.message)),
        (r) => emit(BlogUploadSuccess()),
      );
    });

    on<GetAllBlog>((event, emit) async {
      final res = await _getAllBlogs(NoParams());

      res.fold(
        (l) => emit(BlogFailure(error: l.message)),
        (r) => emit(BlogDisplaySuccess(blogs: r)),
      );
    });
  }
}
