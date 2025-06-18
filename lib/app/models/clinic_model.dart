import 'dart:convert';
import 'dart:math';

class Clinic {
  final int id;
  final String name;
  final String location;
  final String openingTime;
  final String closingTime;
  final List operationDays;
  final String distance;
  final String image;
  final double latitude;
  final double longitude;
  final double averageStars;
  final List tags;

  Clinic({
    required this.id,
    required this.name,
    required this.location,
    required this.openingTime,
    required this.closingTime,
    required this.distance,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.operationDays,
    required this.averageStars,
    required this.tags,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      name: json['name'],
      location: json['address'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      distance: json['distance'] ?? "0",
      operationDays: jsonDecode(json['operation_days'] ?? '[]'),
      image:
          json['image'] ??
          "https://picsum.photos/200/30${Random().nextInt(10)}",
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      averageStars: double.parse(json['stars_average'] ?? "0.0"),
      tags: jsonDecode(json['tags'] ?? '[]'),
    );
  }
}
