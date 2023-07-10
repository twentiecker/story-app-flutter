import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/get_story_response.dart';

class CardWidget extends StatelessWidget {
  final ListStory story;
  final Function(String) onTapped;

  const CardWidget({
    Key? key,
    required this.story, required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapped(story.id),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: story.photoUrl,
            progressIndicatorBuilder: (context, url, progress) =>
                CircularProgressIndicator(value: progress.progress),
          ),
          SizedBox(height: 10),
          Text(story.name),
        ],
      ),
    );
  }
}
