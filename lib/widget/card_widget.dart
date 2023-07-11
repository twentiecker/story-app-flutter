import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../model/get_story_response.dart';
import '../utils/color_theme.dart';

class CardWidget extends StatelessWidget {
  final ListStory story;
  final Function(String) onTapped;

  const CardWidget({
    Key? key,
    required this.story,
    required this.onTapped,
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
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: lightGreen,
                        size: 50,
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: white),
                          ),
                          SizedBox(height: 2),
                          Text(
                            Jiffy.parse(story.createdAt.toLocal().toString())
                                .fromNow(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.grey),
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
                        size: 5,
                      ),
                      SizedBox(height: 2),
                      Icon(
                        Icons.circle_rounded,
                        color: white,
                        size: 5,
                      ),
                      SizedBox(height: 2),
                      Icon(
                        Icons.circle_rounded,
                        color: white,
                        size: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 250,
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
                        )),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
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
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text('Like',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: white)),
                      SizedBox(width: 20),
                      Icon(
                        Icons.comment_outlined,
                        color: white,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text('Comment',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: white)),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Share',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: white)),
                      SizedBox(width: 5),
                      Icon(
                        Icons.share_outlined,
                        color: white,
                        size: 20,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
