import 'package:hive/hive.dart';

import '../models/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl({required this.box});

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    box.clear();

    box.write(() {
      for (var i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    box.read(() {
      for (var i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });

    return blogs;
  }
}
