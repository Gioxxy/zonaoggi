// To parse this JSON data, do
//
//     final regionDetailModel = regionDetailModelFromJson(jsonString);

import 'dart:convert';

RegionDetailModel regionDetailModelFromJson(String str) => RegionDetailModel.fromJson(json.decode(str));

String regionDetailModelToJson(RegionDetailModel data) => json.encode(data.toJson());

class RegionDetailModel {
  RegionDetailModel({
    this.selfDeclaration,
    this.restrictions,
  });

  String selfDeclaration;
  List<RestrictionsModel> restrictions;

  factory RegionDetailModel.fromJson(Map<String, dynamic> json) => RegionDetailModel(
    selfDeclaration: json["selfDeclaration"],
    restrictions: List<RestrictionsModel>.from(json["restrictions"].map((x) => RestrictionsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "selfDeclaration": selfDeclaration,
    "restrictions": List<dynamic>.from(restrictions.map((x) => x.toJson())),
  };
}

class RestrictionsModel {
  RestrictionsModel({
    this.zoneName,
    this.restrictions,
  });

  String zoneName;
  List<RestrictionModel> restrictions;

  factory RestrictionsModel.fromJson(Map<String, dynamic> json) => RestrictionsModel(
    zoneName: json["zoneName"],
    restrictions: List<RestrictionModel>.from(json["restrictions"].map((x) => RestrictionModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "zoneName": zoneName,
    "restrictions": List<dynamic>.from(restrictions.map((x) => x.toJson())),
  };
}

class RestrictionModel {
  RestrictionModel({
    this.icon,
    this.desc,
  });

  String icon;
  String desc;

  factory RestrictionModel.fromJson(Map<String, dynamic> json) => RestrictionModel(
    icon: json["icon"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "desc": desc,
  };
}
