import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'thememodenotifier.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState()=>SettingsPageState();
}
class SettingsPageState extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            leading: const Icon(Icons.person),
            title: const Text('帳號'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '帳號名稱',
                        hintText: '輸入您的帳號名稱',
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '帳號密碼',
                        hintText: '輸入您的更改密碼',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.draw),
            title: const Text('偏好'),
            children:[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: themeNotifier.themeMode,
                      items: <String>['淺色模式', '深色模式']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          themeNotifier.setThemeMode(newValue);
                        }
                      },
                    )
                  ],
                ),
              ),
            ]
          ),
          ExpansionTile(
            leading: Icon(Icons.info),
            title: const Text('關於'),
            children:[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("資工購物平台", style:TextStyle(fontSize: 14)),
              ),
              InkWell(
                onTap: () async {
                  const url = 'https://github.com/ChenGuoXiang940/SC2_myproject';
                  final Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri) && context.mounted) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("不能開啟網址")),
                    );
                  }
                },
                child: const Text(
                  "github 儲存庫網址",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height:16)
            ]
          ),
        ],
      ),
    );
  }
}