import 'package:flutter/material.dart';

class SocialWidget extends StatelessWidget {
  final String source;
  final double ratio;
  final double height;

  const SocialWidget({
    Key? key,
    required this.source,
    required this.ratio,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      source,
      height: ratio * 35,
      scale: height * 0.0016,
    );
  }
}
