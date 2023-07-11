import 'dart:convert';
import 'dart:typed_data';

import 'package:story_app_flutter/model/add_story_response.dart';
import 'package:story_app_flutter/model/login_response.dart';
import 'package:story_app_flutter/model/register_response.dart';
import 'package:http/http.dart' as http;

import '../model/detail_story_response.dart';
import '../model/get_story_response.dart';
import '../model/upload_response.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<RegisterResponse> registerResponse(
    http.Client client,
    String name,
    String email,
    String password,
  ) async {
    final Map<String, String> body = {
      "name": name,
      "email": email,
      "password": password,
    };

    final response = await client.post(
      Uri.parse('$_baseUrl/register'),
      body: body,
    );

    return RegisterResponse.fromJson(json.decode(response.body));
  }

  Future<LoginResponse> loginResponse(
    http.Client client,
    String email,
    String password,
  ) async {
    final Map<String, String> body = {
      "email": email,
      "password": password,
    };

    final response = await client.post(
      Uri.parse('$_baseUrl/login'),
      body: body,
    );

    return LoginResponse.fromJson(json.decode(response.body));
  }

  Future<GetStoryResponse> getStoryResponse(
    http.Client client,
    String token,
  ) async {
    final Map<String, String> headers = {"Authorization": "Bearer $token"};

    final response = await client.get(
      Uri.parse('$_baseUrl/stories'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return GetStoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Load story error');
    }
  }

  Future<DetailStoryResponse> detailStoryResponse(
      http.Client client,
      String token,
      String id,
      ) async {
    final Map<String, String> headers = {"Authorization": "Bearer $token"};

    final response = await client.get(
      Uri.parse('$_baseUrl/stories/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return DetailStoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Load detail story error');
    }
  }

  // Future<AddStoryResponse> addStoryResponse(
  //   List<int> bytes,
  //   String fileName,
  //   String description,
  // ) async {
  //   final uri = Uri.parse('$_baseUrl/stories');
  //   var request = http.MultipartRequest('POST', uri);
  //
  //   final multiPartFile = http.MultipartFile.fromBytes(
  //     "photo",
  //     bytes,
  //     filename: fileName,
  //   );
  //   final Map<String, String> fields = {
  //     "description": description,
  //   };
  //   final Map<String, String> headers = {
  //     "Content-type": "multipart/form-data",
  //     "Authorization": "Bearer <token>"
  //   };
  //
  //   request.files.add(multiPartFile);
  //   request.fields.addAll(fields);
  //   request.headers.addAll(headers);
  //
  //   final http.StreamedResponse streamedResponse = await request.send();
  //   final int statusCode = streamedResponse.statusCode;
  //
  //   final Uint8List responseList = await streamedResponse.stream.toBytes();
  //   final String responseData = String.fromCharCodes(responseList);
  //
  //   if (statusCode == 201) {
  //     final AddStoryResponse response = AddStoryResponse.fromRawJson(
  //       responseData,
  //     );
  //     return response;
  //   } else {
  //     throw Exception("Add story error");
  //   }
  // }

  Future<UploadResponse> uploadDocument(
      List<int> bytes,
      String fileName,
      String description,
      ) async {
    const String url = "https://story-api.dicoding.dev/v1/stories";

    final uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
    };
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJ1c2VyLXJPazR3NTBJXzk4UXkyYTYiLCJpYXQiOjE2ODkwNTUzMjB9.aG2ZJWr8bfQ3eyInY8W-C6SaBHTFH4pbR3ebqCm1s90"
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final UploadResponse uploadResponse = UploadResponse.fromJson(
        responseData,
      );
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
