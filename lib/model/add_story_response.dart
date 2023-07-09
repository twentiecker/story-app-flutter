// To parse this JSON data, do
//
//     final addStoryResponse = addStoryResponseFromJson(jsonString);

import 'dart:convert';

class AddStoryResponse {
  final bool error;
  final String message;

  AddStoryResponse({
    required this.error,
    required this.message,
  });

  factory AddStoryResponse.fromRawJson(String str) =>
      AddStoryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddStoryResponse.fromJson(Map<String, dynamic> json) =>
      AddStoryResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
