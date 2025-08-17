import 'package:pratice0419/presentation/presentation.dart';
import 'package:provider/provider.dart';
import 'package:pratice0419/data/data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pratice0419/core/core.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  void getverificationCode() {
    // 在這裡處理獲取驗證碼的邏輯
    MessageService.showMessage(context, "尚未完成的功能");
  }

  void changePassword() {
    // 在這裡處理更改密碼的邏輯
    MessageService.showMessage(context, "尚未完成的功能");
  }

  void sentFeedback() {
    // 在這裡處理用戶回饋的邏輯
    MessageService.showMessage(context, "尚未完成的功能");
  }

  @override
  Widget build(BuildContext context) {
    String themeName = Provider.of<ThemeProvider>(context).getThemeName();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController verificationpasswordController =
        TextEditingController();
    final TextEditingController verificationCodeController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text('設定')),
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
                      controller: passwordController,
                      obscureText: true,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '確認更改帳號密碼',
                        hintText: '再次輸入您的更改密碼',
                      ),
                      controller: verificationpasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: getverificationCode,
                          child: const Text("獲取驗證碼"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                      children: [
                        ElevatedButton(
                          onPressed: changePassword,
                          child: const Text("更改密碼"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.draw),
            title: const Text('偏好'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('目前主題:', style: TextStyle(fontSize: 16)),
                        DropdownButton<String>(
                          value: themeName,
                          items:
                              <String>[
                                '淺色模式',
                                '深色模式',
                                '系統預設',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                themeName = newValue;
                              });
                              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                                  switch (newValue) {
                                    case '淺色模式':
                                      themeProvider.setThemeMode(AppThemeMode.light);
                                      break;
                                    case '深色模式':
                                      themeProvider.setThemeMode(AppThemeMode.dark);
                                      break;
                                    case '系統預設':
                                      themeProvider.setThemeMode(AppThemeMode.system);
                                      break;
                                  }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.info),
            title: const Text('關於'),
            children: [
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  const url = 'https://github.com/ChenGuoXiang940/SC2_myproject';
                  final Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri) && context.mounted) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("不能開啟網址")));
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('github 儲存庫', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
