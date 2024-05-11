import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChooseImageSource extends StatelessWidget {
  final String asset;
  final String label;

  const ChooseImageSource({
    super.key,
    required this.asset,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Lottie.asset(
          asset,
          height: 170,
          fit: BoxFit.cover,
          repeat: false,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
