// To parse this JSON data, do
//
//     final getStoryResponse = getStoryResponseFromJson(jsonString);

import 'dart:convert';

class   GetStoryResponse {
  final bool error;
  final String message;
  final List<ListStory> listStory;

  GetStoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory GetStoryResponse.fromRawJson(String str) =>
      GetStoryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetStoryResponse.fromJson(Map<String, dynamic> json) =>
      GetStoryResponse(
        error: json["error"],
        message: json["message"],
        listStory: List<ListStory>.from(
            json["listStory"].map((x) => ListStory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
      };
}

class ListStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double lat;
  final double lon;

  ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory ListStory.fromRawJson(String str) =>
      ListStory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListStory.fromJson(Map<String, dynamic> json) => ListStory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: json["lat"] == null ? 0.0 : json["lat"].toDouble(),
        lon: json["lon"] == null ? 0.0 : json["lon"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}
