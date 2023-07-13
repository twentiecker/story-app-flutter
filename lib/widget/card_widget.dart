import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:story_app_flutter/utils/style_theme.dart';

import '../model/get_story_response.dart';
import '../utils/color_theme.dart';

class CardWidget extends StatelessWidget {
  final ListStory story;
  final Function(String) onTapped;
  final Size screenSize;
  final double ratio;

  const CardWidget({
    Key? key,
    required this.story,
    required this.onTapped,
    required this.screenSize,
    required this.ratio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightGrey,
      child: InkWell(
        onTap: () => onTapped(story.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: screenSize.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: story.photoUrl,
                          width: ratio * 50,
                          height: ratio * 50,
                          progressIndicatorBuilder: (context, url, progress) =>
                              CircularProgressIndicator(
                            value: progress.progress,
                            color: white,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.02),
                      // SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.name,
                            style: titleMedium(
                              context,
                              ratio,
                              white,
                              null,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.002),
                          Text(
                            Jiffy.parse(story.createdAt.toLocal().toString())
                                .fromNow(),
                            style: bodyMedium(
                              context,
                              ratio,
                              Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.circle_rounded,
                        color: white,
                        size: ratio * 5,
                      ),
                      SizedBox(height: screenSize.height * 0.002),
                      Icon(
                        Icons.circle_rounded,
                        color: white,
                        size: ratio * 5,
                      ),
                      SizedBox(height: screenSize.height * 0.002),
                      Icon(
                        Icons.circle_rounded,
                        color: white,
                        size: ratio * 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            SizedBox(
              height: screenSize.height * 0.31,
              child: CachedNetworkImage(
                imageUrl: story.photoUrl,
                progressIndicatorBuilder: (context, url, progress) =>
                    Transform.scale(
                  scaleX: 0.3,
                  scaleY: 0.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    value: progress.progress,
                    color: white,
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                        size: ratio * 20,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        'Like',
                        style: titleSmall(
                          context,
                          ratio,
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.05),
                      Icon(
                        Icons.comment_outlined,
                        color: white,
                        size: ratio * 20,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        'Comment',
                        style: titleSmall(
                          context,
                          ratio,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Share',
                        style: titleSmall(
                          context,
                          ratio,
                        ),
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Icon(
                        Icons.share_outlined,
                        color: white,
                        size: ratio * 20,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
          ],
        ),
      ),
    );
  }
}
