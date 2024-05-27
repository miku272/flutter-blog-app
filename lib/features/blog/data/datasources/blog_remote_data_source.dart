import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

import '../models/blog_model.dart';

abstract interface class BlogRemoteDataSource {
  Future<String> uploadBlogImage(File image, BlogModel blog);
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<List<BlogModel>> getAllBlogs();
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
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      // Performing join operation to get the name of the author
      final blogs = await supabaseClient.from('blogs').select(
            '*, profiles (name)',
          );

      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              userName: blog['profiles']['name'],
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }
}
