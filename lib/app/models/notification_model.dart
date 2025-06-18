import 'package:flutter/material.dart';

class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String type;
  final String timeStamp;
  final IconData icon;
  final Color iconColor;
  //final String priority;
  final String? petInfo;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timeStamp,
    required this.icon,
    required this.iconColor,
    //required this.priority,
    this.petInfo,
    this.isRead = false,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'] ?? "",
      body: json['message'] ?? "",
      type: json['category'] ?? "system",
      timeStamp: DateTime.parse(json['created_at']).toLocal().toString(),
      icon: json['icon'] == 'gear' ? Icons.settings : Icons.calendar_month,
      iconColor:
          json['color'] == "red"
              ? Colors.red
              : json['color'] == "green"
              ? Colors.green
              : Colors.blue,
      //priority: json['priority'] as String,
      petInfo: json['pet']['name'] as String?,
      isRead: json['is_read'] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'timeStamp': timeStamp,
      'icon': icon.codePoint,
      'iconColor': iconColor.value,
      //'priority': priority,
      'petInfo': petInfo,
      'isRead': isRead,
    };
  }
}
