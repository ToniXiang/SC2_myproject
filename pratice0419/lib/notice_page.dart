import 'package:flutter/material.dart';
import 'notice_service.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => NoticePageState();
}

class NoticePageState extends State<NoticePage> {
  @override
  Widget build(BuildContext context) {
    if (NoticeService.logs.isEmpty) {
      NoticeService.addLog("沒有任何通知");
    }

    return Scaffold(
      body: NoticeService.logs.isEmpty
          ? const Center(child: Text('沒有任何通知'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: NoticeService.logs.length,
                    itemBuilder: (context, index) {
                      final log = NoticeService.logs[index];
                      final timestamp = log['timestamp'] is DateTime
                          ? (log['timestamp'] as DateTime).toLocal().toString()
                          : log['timestamp'];
                      return ListTile(
                        title: Text(log['message']),
                        subtitle: Text(
                          timestamp,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              NoticeService.removeNotice(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    const Text(
                      '超過 20 筆資料就移除最舊的通知',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ]
                )
              ],
            ),
    );
  }
}