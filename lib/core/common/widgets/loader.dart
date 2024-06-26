import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 100,
      child: Lottie.asset(
        'assets/icons/loading-heart.json',
        repeat: true,
        fit: BoxFit.cover,
      ),
    ));
  }
}
