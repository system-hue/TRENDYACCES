
// Remove or comment out the following line:
// import 'package:flutter/foundation.dart';
class League {
  final int id;
  final String name;
  final String type;
  final String logo;

  League({
    required this.id,
    required this.name,
    required this.type,
    required this.logo,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['league']['id'],
      name: json['league']['name'],
      type: json['league']['type'],
      logo: json['league']['logo'],
    );
  }
}
