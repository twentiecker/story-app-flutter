import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/api/api_service.dart';
import 'package:story_app_flutter/db/auth_repository.dart';
import 'package:story_app_flutter/provider/detail_story_response_provider.dart';
import 'package:story_app_flutter/utils/color_theme.dart';

import '../utils/result_state.dart';
import '../utils/style_theme.dart';
import '../widget/state_widget.dart';

class QuoteDetailsScreen extends StatelessWidget {
  final String quoteId;

  const QuoteDetailsScreen({
    Key? key,
    required this.quoteId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.height / 803.137269;
    return ChangeNotifierProvider(
      create: (BuildContext context) => DetailStoryResponseProvider(
        apiService: ApiService(),
        authRepository: AuthRepository(),
        id: quoteId,
      ),
      child: Consumer<DetailStoryResponseProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Scaffold(
              backgroundColor: grey,
              body: Center(
                child: CircularProgressIndicator(color: white),
              ),
            );
          } else if (state.state == ResultState.hasData) {
            return Scaffold(
              backgroundColor: grey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: screenSize.height * 0.04),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: white,
                                    size: ratio * 24,
                                  ),
                                ),
                                SizedBox(width: screenSize.width * 0.02),
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: state.result.story.photoUrl,
                                    width: ratio * 50,
                                    height: ratio * 50,
                                    progressIndicatorBuilder:
                                        (context, url, progress) =>
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
                                      state.result.story.name,
                                      style: titleMedium(
                                        context,
                                        ratio,
                                        white,
                                        null,
                                      ),
                                    ),
                                    SizedBox(height: screenSize.height * 0.002),
                                    Text(
                                      Jiffy.parse(state.result.story.createdAt
                                              .toLocal()
                                              .toString())
                                          .fromNow(),
                                      style: bodyMedium(
                                          context, ratio, Colors.grey),
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
                          imageUrl: state.result.story.photoUrl,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          state.result.story.description,
                          style: bodyMedium(
                            context,
                            ratio,
                            white,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Scaffold(
              backgroundColor: grey,
              body: Center(
                child: StateWidget(
                  icon: Icons.not_interested_rounded,
                  message: state.message,
                ),
              ),
            );
          } else if (state.state == ResultState.error) {
            return const Scaffold(
              backgroundColor: grey,
              body: Center(
                child: StateWidget(
                  icon: Icons.signal_wifi_connected_no_internet_4_rounded,
                  message: 'No Internet Connection',
                ),
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: grey,
              body: Center(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }
}
