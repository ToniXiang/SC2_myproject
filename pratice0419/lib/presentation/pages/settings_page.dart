import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import '../../data/services/notice_service.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState()=>SettingsPageState();
}
class SettingsPageState extends State<SettingsPage>{
  void changeNotice(bool value) {
    if(value) {
      setState(() {
        NoticeService.isNoticeEnabled = true;
      });
      NoticeService.showSnackBar("通知已啟用", context);
    } else {
      setState(() {
        NoticeService.isNoticeEnabled = false;
      });
      NoticeService.showSnackBar("通知已停用",context);
    }
  }
  void getverificationCode() {
    // 在這裡處理獲取驗證碼的邏輯
    NoticeService.showSnackBar("尚未完成的功能",context);
  }
  void changePassword() {
    // 在這裡處理更改密碼的邏輯
    NoticeService.showSnackBar("尚未完成的功能",context);
  }
  void sentFeedback() {
    // 在這裡處理用戶回饋的邏輯
    NoticeService.showSnackBar("尚未完成的功能",context);
  }
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController verificationpasswordController = TextEditingController();
    final TextEditingController verificationCodeController = TextEditingController();
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
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '姓名',
                        hintText: '輸入您的姓名',
                      ),
                      controller: usernameController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '更改帳號密碼',
                        hintText: '輸入您的更改密碼',
                      ),
                      controller:passwordController,
                      obscureText: true,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '確認更改帳號密碼',
                        hintText: '再次輸入您的更改密碼',
                      ),
                      controller:verificationpasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height:8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                        ElevatedButton(
                          onPressed: getverificationCode,
                          child: const Text("獲取驗證碼"),
                    ),
                      ]
                    ),
                    const SizedBox(height:8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '驗證碼',
                        hintText: '輸入您收到的驗證碼',
                      ),
                      controller: verificationCodeController,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                        ElevatedButton(
                          onPressed: changePassword,
                          child: const Text("更改密碼"),
                        ),
                      ]
                    )
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.notifications),
            title: const Text('通知設定'),
            children: [
              SwitchListTile(
                  value: NoticeService.isNoticeEnabled,
                  title: const Text('啟用通知'),
                  onChanged: (value) {
                    changeNotice(value);
                  },
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '目前主題:',
                          style: TextStyle(fontSize: 16),
                        ),
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
                        ),
                      ],
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
                child: Text("資工購物平台", style:TextStyle(fontSize: 14,fontWeight:FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("軟體介紹: 這是一個簡單的購物應用程式。"),
                    SizedBox(height: 8),
                    Text("1.登入與註冊頁面"),
                    Text("2.主頁面(商品列表)"),
                    Text("3.過去的訂單"),
                    Text("4.登出"),
                    Text("5.設定"),
                  ]
                )
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
              const SizedBox(height:16),
              InkWell(
                onTap: () async {
                  const url = 'https://sc2-myproject.onrender.com/';
                  final Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri) && context.mounted) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("不能開啟網址")),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '介紹網站',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ]
          ),
          ExpansionTile(
            leading: Icon(Icons.feedback),
            title: const Text('用戶回饋'),
            children:[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text("如果您有任何建議或問題，請聯繫我們。"),
                    const SizedBox(height: 8),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: '您的回饋',
                        hintText: '請輸入您的回饋意見',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[
                        const Text("我們會盡快回覆您。"),
                        TextButton(
                          onPressed:sentFeedback,
                          child: const Text("發送回饋")
                        )
                      ]
                    ),
                  ]
                )
              ),
            ]
          ),
        ],
      ),
    );
  }
}