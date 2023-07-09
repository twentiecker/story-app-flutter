import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/provider/get_story_response_provider.dart';
import 'package:story_app_flutter/widget/card_widget.dart';

import '../model/quote.dart';
import '../provider/auth_provider.dart';
import '../utils/result_state.dart';
import '../widget/state_widget.dart';

class QuotesListScreen extends StatelessWidget {
  final List<Quote> quotes;
  final Function(String) onTapped;
  final Function() onLogout;

  const QuotesListScreen({
    Key? key,
    required this.quotes,
    required this.onTapped,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final ratio =
        (screenSize.width / screenSize.height) / (423.529419 / 803.137269);
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
      ),
      body: Consumer<GetStoryResponseProvider>(builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.state == ResultState.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: state.result.listStory
                  .map((story) => CardWidget(story: story))
                  .toList(),
            ),
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: StateWidget(
              icon: Icons.not_interested_rounded,
              message: state.message,
              ratio: ratio,
            ),
          );
        } else if (state.state == ResultState.error) {
          return  Center(
            child: StateWidget(
              icon: Icons.signal_wifi_connected_no_internet_4_rounded,
              message: 'No Internet Connection',
              ratio: ratio,
            ),
          );
        } else {
          return const Center(
            child: Text(''),
          );
        }

        // state.result.listStory.map((e) => print(e.id)).toList();
        // return Text('data');
      }),

      /// todo 18: add FAB and update the UI when button is tapped.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authRead = context.read<AuthProvider>();
          final result = await authRead.logout();
          if (result) onLogout();
        },
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
