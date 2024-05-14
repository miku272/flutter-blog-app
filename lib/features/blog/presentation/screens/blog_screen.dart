import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/blog_fetching_loader.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/show_snackbar.dart';

import '../bloc/blog_bloc.dart';

import '../widgets/blog_card.dart';

import './add_new_blog_screen.dart';
import './blog_viewer_screen.dart';

class BlogScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogScreen(),
      );

  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  void initState() {
    super.initState();

    context.read<BlogBloc>().add(GetAllBlog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(CupertinoIcons.add_circled),
            onPressed: () {
              Navigator.of(context).push(AddNewBlogScreen.route());
            },
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const BlogFetchingLoader();
          }

          if (state is BlogFailure) {
            return const Center(
              child: Text('Failed to fetch blogs. Please try again later.'),
            );
          }

          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      BlogViewerScreen.route(state.blogs[index]),
                    );
                  },
                  child: BlogCard(
                    blog: state.blogs[index],
                    color: index % 3 == 0
                        ? AppPallete.gradient1
                        : index % 3 == 1
                            ? AppPallete.gradient2
                            : AppPallete.gradient3,
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
