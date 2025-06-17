import 'package:flutter/material.dart';
class NoticeService{
  static List<String> notices = [];
  static bool isNoticeEnabled = true;
  final List<String> defaultNotices = [
    "歡迎使用本應用程式！",
    "請定期檢查更新以獲取最新功能。",
    "如有任何問題，請聯繫我。",
  ];
  NoticeService() {
    notices.addAll(defaultNotices);
  }
  static void addNotice(String notice) {
    if (isNoticeEnabled) {
      notices.add(notice);
    }
  }
  static void removeAllNotices() {
    notices.clear();
  }
  static Future<List<String>> getNotices() async {
    return Future.value(notices);
  }
  static void showSnackBar(String message, BuildContext context) {
    if (!isNoticeEnabled) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}