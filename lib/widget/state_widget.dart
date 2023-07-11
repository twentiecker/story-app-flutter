import 'package:flutter/material.dart';

import '../utils/color_theme.dart';

class StateWidget extends StatelessWidget {
  final IconData icon;
  final String message;

  const StateWidget({
    Key? key,
    required this.icon,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final ratio =
        (screenSize.width / screenSize.height) / (423.529419 / 803.137269);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: ratio * 100,
          color: white,
        ),
        SizedBox(height: ratio * 5),
        Text('$message!', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: white),),
      ],
    );
  }
}
