import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api_service.dart';
import '../db/auth_repository.dart';
import '../model/detail_story_response.dart';
import '../utils/result_state.dart';

class DetailStoryResponseProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;
  final String id;

  DetailStoryResponseProvider({
    required this.apiService,
    required this.authRepository,
    required this.id,
  }) {
    _fetchDetailStoryResponse();
  }

  late DetailStoryResponse _detailStoryResponse;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailStoryResponse get result => _detailStoryResponse;

  ResultState get state => _state;

  Future<dynamic> _fetchDetailStoryResponse() async {
    try {
      final String token = await authRepository.getToken();
      _state = ResultState.loading;
      notifyListeners();
      final detailStoryResponse =
          await apiService.detailStoryResponse(http.Client(), token, id);
      if (detailStoryResponse.toString().isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailStoryResponse = detailStoryResponse;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
