import 'package:flutter/material.dart';

class NoticeService {
  static List<Map<String, dynamic>> logs = [];
  static bool isNoticeEnabled = true;

  static void addLog(String notice) {
    if (!isNoticeEnabled) return;

    if (logs.length >= 20) {
      logs.removeAt(0);
    }

    logs.add({"message": notice, "timestamp": DateTime.now()});
  }

  static void removeAllNotices() {
    logs.clear();
  }

  static void removeNotice(int index) {
    if (index >= 0 && index < logs.length) {
      logs.removeAt(index);
    }
  }

  static void showSnackBar(String message, BuildContext context) {
    if (!isNoticeEnabled) return;
    addLog(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}