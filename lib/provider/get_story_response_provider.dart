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
    _fetchGetStoryResponse();
    _getStoryResponse =
        GetStoryResponse(error: false, message: 'Loading...', listStory: []);
    _state = ResultState.loading;
  }

  late GetStoryResponse _getStoryResponse;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  GetStoryResponse get result => _getStoryResponse;

  ResultState get state => _state;

  Future<dynamic> _fetchGetStoryResponse() async {
    try {
      final String token = await authRepository.getToken();
      _state = ResultState.loading;
      notifyListeners();
      final getStoryResponse =
          await apiService.getStoryResponse(http.Client(), token);
      if (getStoryResponse.listStory.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _getStoryResponse = getStoryResponse;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
