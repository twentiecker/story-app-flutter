import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/model/get_story_response.dart';
import 'package:story_app_flutter/utils/color_theme.dart';
import 'package:story_app_flutter/utils/style_theme.dart';
import 'package:story_app_flutter/widget/account_widget.dart';
import 'package:story_app_flutter/widget/card_widget.dart';

import '../provider/auth_provider.dart';

class StoryListScreen extends StatelessWidget {
  final List<ListStory> quotes;
  final Function(String) onTapped;
  final Function() onLogout;
  final Function() onAddStory;

  const StoryListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.onLogout,
    required this.onAddStory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.height / 803.137269;
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: grey,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stories',
                    style: headlineSmall(
                      context,
                      ratio,
                    ),
                  ),
                  InkWell(
                    onTap: () => onAddStory(),
                    child: Row(
                      children: [
                        Text(
                          'Add story',
                          style: titleSmall(
                            context,
                            ratio,
                          ),
                        ),
                        SizedBox(width: screenSize.width * 0.01),
                        Icon(
                          Icons.add_box_outlined,
                          color: white,
                          size: ratio * 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            SizedBox(
              height: screenSize.height * 0.14,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: quotes.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return AccountWidget(
                      imgUrl: quotes[index].photoUrl,
                      name: quotes[index].name,
                      leftPad: 20,
                      rightPad: 0,
                      ratio: ratio,
                    );
                  } else if (index >= 1 && index < quotes.length - 1) {
                    return AccountWidget(
                      imgUrl: quotes[index].photoUrl,
                      name: quotes[index].name,
                      leftPad: 10,
                      rightPad: 0,
                      ratio: ratio,
                    );
                  } else if (index == quotes.length - 1) {
                    return AccountWidget(
                      imgUrl: quotes[index].photoUrl,
                      name: quotes[index].name,
                      leftPad: 10,
                      rightPad: 20,
                      ratio: ratio,
                    );
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: quotes
                      .map((story) => CardWidget(
                            story: story,
                            onTapped: onTapped,
                            screenSize: screenSize,
                            ratio: ratio,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) onLogout();
        },
        backgroundColor: green,
        tooltip: "Logout",
        child: authWatch.isLoadingLogout
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.logout),
      ),
    );
  }
}
