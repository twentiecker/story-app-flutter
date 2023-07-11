import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/api/api_service.dart';
import 'package:story_app_flutter/db/auth_repository.dart';
import 'package:story_app_flutter/provider/detail_story_response_provider.dart';
import 'package:story_app_flutter/utils/color_theme.dart';

import '../model/quote.dart';
import '../utils/result_state.dart';
import '../widget/state_widget.dart';

class QuoteDetailsScreen extends StatelessWidget {
  final String quoteId;

  const QuoteDetailsScreen({
    Key? key,
    required this.quoteId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final quote = quotes.singleWhere((element) => element.id == quoteId);
    return ChangeNotifierProvider(
      create: (BuildContext context) => DetailStoryResponseProvider(
          apiService: ApiService(),
          authRepository: AuthRepository(),
          id: quoteId),
      child: Consumer<DetailStoryResponseProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return Scaffold(
              backgroundColor: grey,
              body: Center(
                child: CircularProgressIndicator(color: white,),
              ),
            );
          } else if (state.state == ResultState.hasData) {
            return Scaffold(
              // appBar: AppBar(
              //   title: Text(state.result.story.name),
              // ),
              backgroundColor: grey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.perm_contact_cal_rounded,
                                  color: lightGreen,
                                  size: 50,
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.result.story.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: white),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      Jiffy.parse(state.result.story.createdAt.toLocal().toString())
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
                      SizedBox(
                        height: 400,
                        child: CachedNetworkImage(
                          imageUrl: state.result.story.photoUrl,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Transform.scale(
                                  scale: 0.3,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    value: progress.progress,
                                    color: white,
                                  )),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                            // Text(state.result.story.name, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: white)),
                            SizedBox(height: 15),
                            Text(state.result.story.description,
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: white)),
                          ],
                        ),
                      ),

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
            return Scaffold(
              backgroundColor: grey,
              body: Center(
                child: StateWidget(
                  icon: Icons.signal_wifi_connected_no_internet_4_rounded,
                  message: 'No Internet Connection',
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: grey,
              body: const Center(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }
}
