import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './add_new_blog_screen.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

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
    );
  }
}
