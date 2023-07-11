import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/model/get_story_response.dart';
import 'package:story_app_flutter/provider/get_story_response_provider.dart';
import 'package:story_app_flutter/utils/color_theme.dart';
import 'package:story_app_flutter/widget/card_widget.dart';

import '../api/api_service.dart';
import '../model/quote.dart';
import '../provider/auth_provider.dart';
import '../provider/home_provider.dart';
import '../provider/upload_provider.dart';
import '../utils/result_state.dart';
import '../widget/state_widget.dart';

class QuotesListScreen extends StatelessWidget {
  final List<ListStory> quotes;
  final Function(String) onTapped;
  final Function() onLogout;
  final Function() onAddStory;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.onLogout,
    required this.onAddStory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;
    // final ratio =
    //     (screenSize.width / screenSize.height) / (423.529419 / 803.137269);
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Story App"),
      // ),
      backgroundColor: grey,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stories',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                        color: lightGreen, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () => onAddStory(),
                    child: Row(
                      children: [
                        Text('Add story',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: white)),
                        SizedBox(width: 5),
                        Icon(
                          Icons.add_box_outlined,
                          color: white,
                          size: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  children: [
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: lightGreen,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                    Icon(
                      Icons.perm_contact_cal_rounded,
                      color: Colors.grey,
                      size: 80,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: quotes
                      .map((story) =>
                      CardWidget(story: story, onTapped: onTapped))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      // Consumer<GetStoryResponseProvider>(builder: (context, state, _) {
      //   if (state.state == ResultState.loading) {
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   } else if (state.state == ResultState.hasData) {
      //     return SingleChildScrollView(
      //       child: Column(
      //         children: quotes
      //             .map((story) => CardWidget(story: story, onTapped: onTapped))
      //             .toList(),
      //       ),
      //     );
      //   } else if (state.state == ResultState.noData) {
      //     return Center(
      //       child: StateWidget(
      //         icon: Icons.not_interested_rounded,
      //         message: state.message,
      //         ratio: ratio,
      //       ),
      //     );
      //   } else if (state.state == ResultState.error) {
      //     return  Center(
      //       child: StateWidget(
      //         icon: Icons.signal_wifi_connected_no_internet_4_rounded,
      //         message: 'No Internet Connection',
      //         ratio: ratio,
      //       ),
      //     );
      //   } else {
      //     return const Center(
      //       child: Text(''),
      //     );
      //   }
      // }),

      /// todo 18: add FAB and update the UI when button is tapped.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) onLogout();
        },
        backgroundColor: green,
        tooltip: "Logout",
        child: authWatch.isLoadingLogout
            ? const CircularProgressIndicator(
          color: Colors.white,
        )
            : const Icon(Icons.logout),
      ),
    );
  }
}
