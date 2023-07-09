import 'package:flutter/material.dart';

class StateWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final double ratio;

  const StateWidget({
    Key? key,
    required this.icon,
    required this.message,
    required this.ratio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: ratio * 100,
        ),
        SizedBox(height: ratio * 5),
        Text('$message!'),
      ],
    );
  }
}
