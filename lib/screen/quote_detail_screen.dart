import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/api/api_service.dart';
import 'package:story_app_flutter/db/auth_repository.dart';
import 'package:story_app_flutter/provider/detail_story_response_provider.dart';

import '../model/quote.dart';

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
          return Scaffold(
            appBar: AppBar(
              title: Text(state.result.story.name),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.result.story.id, style: Theme.of(context).textTheme.headline6),
                  Text(state.result.story.description, style: Theme.of(context).textTheme.subtitle1),
                  Text(state.result.story.photoUrl, style: Theme.of(context).textTheme.subtitle1),
                  Text(state.result.story.createdAt.toString(), style: Theme.of(context).textTheme.subtitle1),
                  Text(state.result.story.lat.toString(), style: Theme.of(context).textTheme.subtitle1),
                  Text(state.result.story.lon.toString(), style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
          );
        },
      )
      ,
    );
  }
}
