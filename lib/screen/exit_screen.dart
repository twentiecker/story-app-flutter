import 'package:flutter/material.dart';

import '../utils/color_theme.dart';
import '../widget/state_widget.dart';

class ExitScreen extends StatelessWidget {
  const ExitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: grey,
      body: Center(
        child: StateWidget(
          icon: Icons.exit_to_app_outlined,
          message: 'Press back again to exit!',
        ),
      ),
    );
  }
}
