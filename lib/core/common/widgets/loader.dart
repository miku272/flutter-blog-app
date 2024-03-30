import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum LoaderSize {
  small,
  medium,
  large,
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      'assets/icons/loading-heart.json',
      repeat: true,
    ));
  }
}
