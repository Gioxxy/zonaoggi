// To parse this JSON data, do
//
//     final day = dayFromJson(jsonString);

import 'dart:convert';

import 'dart:ui';

import 'package:zonaoggi/utils/HexColor.dart';

List<Day> homeModelFromJson(String str) => List<Day>.from(json.decode(str).map((x) => Day.fromJson(x)));

String homeModelToJson(List<Day> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Day {
  Day({
    this.date,
    this.regions,
  });

  DateTime date;
  List<Region> regions;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    date: DateTime.parse(json["date"]),
    regions: List<Region>.from(json["regions"].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "regions": List<dynamic>.from(regions.map((x) => x.toJson())),
  };
}

class Region {
  Region({
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

  factory Region.fromJson(Map<String, dynamic> json) => Region(
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
