// To parse this JSON data, do
//
//     final points = pointsFromJson(jsonString);

import 'dart:convert';

Points pointsFromJson(String str) => Points.fromJson(json.decode(str));

String pointsToJson(Points data) => json.encode(data.toJson());

class Points {
  Points({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory Points.fromJson(Map<String, dynamic> json) => Points(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.points,
    this.value,
  });

  int points;
  double value;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    points: json["points"],
    value: json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "points": points,
    "value": value,
  };
}
