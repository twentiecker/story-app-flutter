import 'package:flutter/material.dart';
import 'package:story_app_flutter/utils/style_theme.dart';

import '../utils/color_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.height / 803.137269;
    return Scaffold(
      backgroundColor: grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'story',
                  style: displaySmall(
                    context,
                    ratio,
                    white,
                  ),
                ),
                Text(
                  'app',
                  style: displaySmall(
                    context,
                    ratio,
                    lightGreen,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
