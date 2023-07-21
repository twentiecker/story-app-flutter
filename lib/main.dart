import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/api/api_service.dart';
import 'package:story_app_flutter/provider/auth_provider.dart';
import 'package:story_app_flutter/provider/add_story_image_provider.dart';
import 'package:story_app_flutter/provider/add_story_provider.dart';
import 'package:story_app_flutter/routes/router_delegate.dart';

import 'db/auth_repository.dart';

void main() {
  runApp(const StoryApp());
}

class StoryApp extends StatefulWidget {
  const StoryApp({Key? key}) : super(key: key);

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();

    authProvider = AuthProvider(authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(
          create: (context) => AddStoryImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddStoryProvider(ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Story App',
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
