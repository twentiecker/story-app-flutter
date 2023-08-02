import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/provider/get_story_response_provider.dart';
import 'package:story_app_flutter/utils/color_theme.dart';
import 'package:story_app_flutter/utils/style_theme.dart';
import 'package:story_app_flutter/widget/account_widget.dart';
import 'package:story_app_flutter/widget/card_widget.dart';

import '../provider/auth_provider.dart';

class StoryListScreen extends StatefulWidget {
  final GetStoryResponseProvider data;
  final Function(String) onTapped;
  final Function() onLogout;
  final Function() onAddStory;

  const StoryListScreen(
      {Key? key,
      required this.data,
      required this.onTapped,
      required this.onLogout,
      required this.onAddStory})
      : super(key: key);

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final getStoryResponseProvider = context.read<GetStoryResponseProvider>();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (getStoryResponseProvider.pageItems != null) {
          getStoryResponseProvider.fetchGetStoryResponse();
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

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
                    onTap: () => widget.onAddStory(),
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
                itemCount: widget.data.stories.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return AccountWidget(
                      imgUrl: widget.data.stories[index].photoUrl,
                      name: widget.data.stories[index].name,
                      leftPad: 20,
                      rightPad: 0,
                      ratio: ratio,
                    );
                  } else if (index >= 1 &&
                      index < widget.data.stories.length - 1) {
                    return AccountWidget(
                      imgUrl: widget.data.stories[index].photoUrl,
                      name: widget.data.stories[index].name,
                      leftPad: 10,
                      rightPad: 0,
                      ratio: ratio,
                    );
                  } else if (index == widget.data.stories.length - 1) {
                    return AccountWidget(
                      imgUrl: widget.data.stories[index].photoUrl,
                      name: widget.data.stories[index].name,
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
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.data.stories.length +
                    (widget.data.pageItems != null ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == widget.data.stories.length &&
                      widget.data.pageItems != null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return CardWidget(
                    story: widget.data.stories[index],
                    onTapped: widget.onTapped,
                    screenSize: screenSize,
                    ratio: ratio,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) widget.onLogout();
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
