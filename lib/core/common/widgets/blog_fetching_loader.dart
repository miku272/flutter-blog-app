import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BlogFetchingLoader extends StatelessWidget {
  const BlogFetchingLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 100,
      child: Lottie.asset(
        'assets/icons/animated-newspaper.json',
        repeat: true,
        fit: BoxFit.cover,
      ),
    ));
  }
}
