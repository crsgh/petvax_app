import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petvax/app/constants/strings.dart';
import 'package:petvax/app/models/notification_model.dart';
import 'package:petvax/screens/all/utility/settings_controller.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationItem>[].obs;
  var unreadCount = 0.obs;
  GetConnect connect = GetConnect();
  Settings settings = Get.find<Settings>();

  @override
  void onInit() {
    connect.baseUrl = AppStrings.baseUrl;
    unreadCount(settings.notifications.where((e) => !e.isRead).length);
    super.onInit();
  }

  void markAsRead(String id) async {
    int index = settings.notifications.indexWhere((n) => n.id.toString() == id);

    if (index != -1) {
      settings.notifications[index].isRead = true;

      var res = await connect.get('notification/read/$id');
      print("notification read: ${res.body}");
      await settings.fetchNotifications();
      notifications.refresh();
      updateUnreadCount();
    }
  }

  void removeNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    updateUnreadCount();
  }

  void markAllAsRead() async {
    for (var notification in notifications) {
      notification.isRead = true;
    }

    var res = await connect.get('notification/read/all/${settings.user!.id}');
    print("notification read all: ${res.body}");

    await settings.fetchNotifications();

    notifications.refresh();
    updateUnreadCount();
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF10B981);
    }
  }
}

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
