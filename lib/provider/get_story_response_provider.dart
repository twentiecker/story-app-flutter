import 'package:flutter/foundation.dart';
import 'package:story_app_flutter/model/get_story_response.dart';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../db/auth_repository.dart';
import '../utils/result_state.dart';

class GetStoryResponseProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;

  GetStoryResponseProvider({
    required this.apiService,
    required this.authRepository,
  }) {
    fetchGetStoryResponse();
    _getStoryResponse =
        GetStoryResponse(error: false, message: 'Loading...', listStory: []);
    _state = ResultState.loading;
    _stories = [];
  }

  int? pageItems = 1;
  int sizeItems = 10;

  late GetStoryResponse _getStoryResponse;
  late ResultState _state;
  late List<ListStory> _stories;

  String _message = '';

  String get message => _message;

  GetStoryResponse get result => _getStoryResponse;

  ResultState get state => _state;

  List<ListStory> get stories => _stories;

  Future<dynamic> fetchGetStoryResponse() async {
    try {
      final String token = await authRepository.getToken();
      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }

      notifyListeners();
      final getStoryResponse = await apiService.getStoryResponse(
          http.Client(), token, pageItems!, sizeItems);

      if (getStoryResponse.listStory.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }

      if (getStoryResponse.listStory.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return getStoryResponse.listStory.isNotEmpty
            ? _stories.addAll(getStoryResponse.listStory)
            : _stories;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
