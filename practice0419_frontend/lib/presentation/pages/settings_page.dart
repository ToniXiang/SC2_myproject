import 'package:practice0419_frontend/presentation/presentation.dart';
import 'package:provider/provider.dart';
import 'package:practice0419_frontend/data/data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:practice0419_frontend/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final passwordController = TextEditingController();
  final verificationPasswordController = TextEditingController();
  final verificationCodeController = TextEditingController();
  final storage = FlutterSecureStorage();
  String username = 'user';
  String email = 'user@example.com';
  String? token;

  Future<void> getVerificationCode() async {
    try {
      final response = await ApiService.postRequest(
        'api/send_verification_code/',
        {'email': email},
        token: token,
      );
      if (!mounted) return;
      MessageService.showMessage(context, response['message']);
    } catch (e) {
      MessageService.showMessage(context, '$e');
    }
  }

  Future<void> changePassword() async {
    final newPassword = passwordController.text;
    final confirmPassword = verificationPasswordController.text;
    final code = verificationCodeController.text;

    if (newPassword != confirmPassword) {
      MessageService.showMessage(context, '密碼與確認密碼不一致');
      return;
    }
    try {
      final responseData = await ApiService.postRequest('api/reset_password/', {
        'email': email,
        'password': newPassword,
        'code': code,
      }, token: token);
      if (!mounted) return;
      MessageService.showMessage(context, responseData['message']);
    } catch (e) {
      MessageService.showMessage(context, '$e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      token = await storage.read(key: 'auth_token');
      if (token == null) return;
      final responseData = await ApiService.getRequest('api/user/info', token: token);
      setState(() {
        username = responseData['username'] ?? 'user';
        email = responseData['email'] ?? 'user@example.com';
      });
      if(!mounted) return;
    } catch (e) {
      MessageService.showMessage(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String themeName = Provider.of<ThemeProvider>(context).getThemeName();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      '帳號',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(username, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(email, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  _PasswordInput(
                    context: context,
                    labelText: '新密碼',
                    hintText: '輸入新密碼',
                    icon: Icon(Icons.lock_outline),
                    controller: passwordController,
                  ),
                  const SizedBox(height: 8),
                  _PasswordInput(
                    context: context,
                    labelText: '確認密碼',
                    hintText: '再次輸入',
                    icon: Icon(Icons.lock_outline),
                    controller: verificationPasswordController,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: getVerificationCode,
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: theme.colorScheme.primary),
                        ),
                        child: const Text("獲取驗證碼"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _PasswordInput(
                    context: context,
                    labelText: '驗證碼',
                    hintText: '輸入驗證碼',
                    icon: Icon(Icons.lock_outline),
                    controller: verificationCodeController,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: changePassword,
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                      child: const Text("更改密碼"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Card(
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.palette),
                    title: Text(
                      '主題',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text("淺色"),
                        selected: themeName == "淺色模式",
                        onSelected: (_) {
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).setThemeMode(AppThemeMode.light);
                          setState(() => themeName = "淺色模式");
                        },
                      ),
                      ChoiceChip(
                        label: const Text("深色"),
                        selected: themeName == "深色模式",
                        onSelected: (_) {
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).setThemeMode(AppThemeMode.dark);
                          setState(() => themeName = "深色模式");
                        },
                      ),
                      ChoiceChip(
                        label: const Text("系統"),
                        selected: themeName == "系統預設",
                        onSelected: (_) {
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).setThemeMode(AppThemeMode.system);
                          setState(() => themeName = "系統預設");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Card(
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('GitHub 儲存庫'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () async {
                    const url =
                        'https://github.com/ChenGuoXiang940/SC2_myproject';
                    final Uri uri = Uri.parse(url);
                    if (await canLaunchUrl(uri) && context.mounted) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text("不能開啟網址")));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _PasswordInput extends StatefulWidget {
  final BuildContext context;
  final String labelText;
  final String hintText;
  final Icon icon;
  final TextEditingController controller;

  const _PasswordInput({
    required this.context,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.controller,
  });

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: widget.icon,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}

