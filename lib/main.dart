import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/api/api_service.dart';
import 'package:story_app_flutter/model/get_story_response.dart';
import 'package:story_app_flutter/model/register_response.dart';
import 'package:story_app_flutter/provider/auth_provider.dart';
import 'package:story_app_flutter/provider/detail_story_response_provider.dart';
import 'package:story_app_flutter/provider/get_story_response_provider.dart';
import 'package:story_app_flutter/provider/home_provider.dart';
import 'package:story_app_flutter/provider/upload_provider.dart';
import 'package:story_app_flutter/routes/router_delegate.dart';
import 'package:http/http.dart' as http;

import 'db/auth_repository.dart';
import 'model/login_response.dart';

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

  /// todo 6: add variable for create instance
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();

    authProvider = AuthProvider(authRepository);

    /// todo 7: inject auth to router delegate
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(
            ApiService(),
          ),
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

    // ChangeNotifierProvider(
    //   create: (context) => authProvider,
    //   child: MaterialApp(
    //     title: 'Story App',
    //     home: Router(
    //       routerDelegate: myRouterDelegate,
    //       backButtonDispatcher: RootBackButtonDispatcher(),
    //     ),
    //   ),
    // );
  }
}

// Contoh dari dicoding
//
// void main() {
//   /// todo-03-upload-06: inject a UploadProvider to main widget
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => HomeProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => UploadProvider(
//             ApiService(),
//           ),
//         ),
//       ],
//       child: const MaterialApp(
//         home: HomePage(),
//       ),
//     ),
//   );
// }
