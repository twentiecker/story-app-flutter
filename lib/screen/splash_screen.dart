import 'package:flutter/material.dart';

import '../utils/color_theme.dart';

/// todo 13: create SplashScreen
class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
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
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'app',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: lightGreen, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
