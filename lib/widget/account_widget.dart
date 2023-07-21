import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story_app_flutter/utils/style_theme.dart';

import '../utils/color_theme.dart';

class AccountWidget extends StatelessWidget {
  final String imgUrl;
  final String name;
  final double leftPad;
  final double rightPad;
  final double ratio;

  const AccountWidget({
    Key? key,
    required this.imgUrl,
    required this.name,
    required this.leftPad,
    required this.rightPad,
    required this.ratio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPad,
        right: rightPad,
      ),
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              width: ratio * 60,
              height: ratio * 60,
              progressIndicatorBuilder: (context, url, progress) =>
                  CircularProgressIndicator(
                value: progress.progress,
                color: white,
              ),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: ratio * 5),
          SizedBox(
            width: ratio * 60,
            child: Center(
              child: Text(
                name,
                style: bodyMedium(
                  context,
                  ratio,
                  Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
