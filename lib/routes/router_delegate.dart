import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/api/api_service.dart';
import 'package:story_app_flutter/screen/camera_screen.dart';
import 'package:story_app_flutter/screen/exit_screen.dart';
import 'package:story_app_flutter/screen/story_create_screen.dart';
import 'package:story_app_flutter/utils/color_theme.dart';

import '../db/auth_repository.dart';
import '../provider/get_story_response_provider.dart';
import '../screen/login_screen.dart';
import '../screen/story_detail_screen.dart';
import '../screen/strory_list_screen.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';
import '../utils/result_state.dart';
import '../widget/state_widget.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedQuote;
  List<CameraDescription>? listCameras;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAddStory = false;
  bool isListStory = true;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isAddStory == true || selectedQuote != null
            ? isListStory = true
            : isListStory = false;
        isRegister = false;
        selectedQuote = null;
        listCameras != null ? isAddStory = true : isAddStory = false;
        listCameras = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashScreen"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        const MaterialPage(
          key: ValueKey("ConfirmPage"),
          child: ExitScreen(),
        ),
        if (isListStory == true)
          MaterialPage(
            key: const ValueKey("StoryListPage"),
            child: ChangeNotifierProvider(
              create: (BuildContext context) => GetStoryResponseProvider(
                apiService: ApiService(),
                authRepository: authRepository,
              ),
              child: Consumer<GetStoryResponseProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.loading) {
                    return const Scaffold(
                      backgroundColor: grey,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: white,
                        ),
                      ),
                    );
                  } else if (state.state == ResultState.hasData) {
                    return StoryListScreen(
                      data: state,
                      onTapped: (String quoteId) {
                        selectedQuote = quoteId;
                        notifyListeners();
                      },
                      onLogout: () {
                        isLoggedIn = false;
                        notifyListeners();
                      },
                      onAddStory: () {
                        isAddStory = true;
                        isListStory = false;
                        notifyListeners();
                      },
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
                          icon:
                              Icons.signal_wifi_connected_no_internet_4_rounded,
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
            ),
          ),
        if (selectedQuote != null)
          MaterialPage(
            key: ValueKey(selectedQuote),
            child: StoryDetailScreen(
              quoteId: selectedQuote!,
              onListStory: () {
                selectedQuote = null;
                notifyListeners();
              },
            ),
          ),
        if (isAddStory == true && listCameras == null)
          MaterialPage(
            key: const ValueKey("StoryCreatePage"),
            child: StoryCreateScreen(
              onListStory: () {
                isAddStory = false;
                isListStory = true;
                notifyListeners();
              },
              onCamera: (List<CameraDescription> cameras) {
                listCameras = cameras;
                notifyListeners();
              },
            ),
          ),
        if (listCameras != null)
          MaterialPage(
            key: ValueKey(listCameras),
            child: CameraScreen(
              cameras: listCameras!,
              onCreateStory: () {
                listCameras = null;
                notifyListeners();
              },
            ),
          ),
      ];
}
