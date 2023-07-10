import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/api/api_service.dart';
import 'package:story_app_flutter/model/get_story_response.dart';

import '../db/auth_repository.dart';
import '../model/quote.dart';
import '../provider/get_story_response_provider.dart';
import '../screen/login_screen.dart';
import '../screen/quote_detail_screen.dart';
import '../screen/quotes_list_screen.dart';
import '../screen/register_screen.dart';
import '../screen/splash_screen.dart';
import '../utils/result_state.dart';
import '../widget/state_widget.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(
    this.authRepository,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    /// todo 9: create initial function to check user logged in.
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedQuote;

  /// todo 8: add historyStack variable to maintaining the stack
  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    /// todo 11: create conditional statement to declare historyStack based on  user logged in.
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,

      /// todo 10: change the list with historyStack
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegister = false;
        selectedQuote = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }

  /// todo 12: add these variable to support history stack
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
            /// todo 17: add onLogin and onRegister method to update the state
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
        MaterialPage(
          key: const ValueKey("QuotesListPage"),
          child: ChangeNotifierProvider(
            create: (BuildContext context) => GetStoryResponseProvider(
                apiService: ApiService(), authRepository: authRepository),
            child: Consumer<GetStoryResponseProvider>(
              builder: (context, state, _) {
                if (state.state == ResultState.loading) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state.state == ResultState.hasData) {
                  return QuotesListScreen(
                    quotes: state.result.listStory,
                    onTapped: (String quoteId) {
                      selectedQuote = quoteId;
                      notifyListeners();
                    },

                    /// todo 21: add onLogout method to update the state and
                    /// create a logout button
                    onLogout: () {
                      isLoggedIn = false;
                      notifyListeners();
                    },
                  );
                } else if (state.state == ResultState.noData) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: StateWidget(
                        icon: Icons.not_interested_rounded,
                        message: state.message,
                      ),
                    ),
                  );
                } else if (state.state == ResultState.error) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: StateWidget(
                        icon: Icons.signal_wifi_connected_no_internet_4_rounded,
                        message: 'No Internet Connection',
                      ),
                    ),
                  );
                } else {
                  return Scaffold(
                    appBar: AppBar(),
                    body: const Center(
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
            child: QuoteDetailsScreen(
              quoteId: selectedQuote!,
            ),
          ),
      ];
}
