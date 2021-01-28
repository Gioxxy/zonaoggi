// To parse this JSON data, do
//
//     final day = dayFromJson(jsonString);

import 'dart:convert';

import 'dart:ui';

import 'package:zonaoggi/utils/HexColor.dart';

List<DayModel> homeModelFromJson(String str) => List<DayModel>.from(json.decode(str).map((x) => DayModel.fromJson(x)));

String homeModelToJson(List<DayModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DayModel {
  DayModel({
    this.date,
    this.regions,
  });

  DateTime date;
  List<RegionModel> regions;

  factory DayModel.fromJson(Map<String, dynamic> json) => DayModel(
    date: DateTime.parse(json["date"]),
    regions: List<RegionModel>.from(json["regions"].map((x) => RegionModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "regions": List<dynamic>.from(regions.map((x) => x.toJson())),
  };
}

class RegionModel {
  RegionModel({
    this.id,
    this.name,
    this.color,
    this.zoneName,
    this.image,
  });

  int id;
  String name;
  Color color;
  String zoneName;
  String image;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    id: json["id"],
    name: json["name"],
    color: HexColor(json["color"]),
    zoneName: json["zoneName"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "color": color.value,
    "zoneName": zoneName,
    "image": image,
  };
}
