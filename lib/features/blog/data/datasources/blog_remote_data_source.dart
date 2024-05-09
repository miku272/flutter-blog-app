import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

import '../models/blog_model.dart';

abstract interface class BlogRemoteDataSource {
  Future<String> uploadBlogImage(File image, BlogModel blog);
  Future<BlogModel> uploadBlog(BlogModel blog);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> uploadBlogImage(File image, BlogModel blog) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();

      return BlogModel.fromJson(blogData.first);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }
}
