import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/calculate_reading_time.dart';
import '../../../../core/utils/format_date.dart';

import '../../domain/entities/blog.dart';

class BlogViewerScreen extends StatelessWidget {
  static route([Blog? blog]) => MaterialPageRoute(
        builder: (context) => BlogViewerScreen(blog: blog),
      );

  final Blog? blog;

  const BlogViewerScreen({
    super.key,
    this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: blog == null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      'assets/illustrations/animated-natural-something-went-wrong.json',
                      repeat: true,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This blog does not exist or maybe it\'s lost in the sea of blogs...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        blog!.title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'By ${blog!.userName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${formatDatedMMYYYY(blog!.updatedAt)} . ${calculateReadingTime(blog!.content)} min',
                        style: const TextStyle(
                          color: AppPallete.greyColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          blog!.imageUrl,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error,
                                size: 50,
                                color: AppPallete.greyColor,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        blog!.content,
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1.6,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
