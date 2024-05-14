import 'package:flutter/material.dart';

import '../../../../core/utils/calculate_reading_time.dart';

import '../../domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;

  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: blog.title,
      child: Container(
        margin: const EdgeInsets.all(16.0).copyWith(bottom: 10.0),
        padding: const EdgeInsets.all(16.0),
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map(
                          (e) => Chip(
                            label: Text(e),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  blog.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              '${calculateReadingTime(blog.content)} min read',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
