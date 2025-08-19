import 'package:pratice0419/presentation/presentation.dart';
import 'package:pratice0419/data/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool isLoading = false;
  void login() async {
    try {
      setState(() {
        isLoading = true;
      });
      final responseData = await ApiService.postRequest('api/login/', {
        'email': emailController.text,
        'password': passwordController.text,
      });
      if (responseData.containsKey('token') &&
          responseData.containsKey('username')) {
        String token = responseData['token'] ?? "未知Token";
        String username = responseData['username'] ?? "未知使用者";
        await saveToken(token);
        if (mounted) {
          MessageService.showMessage(context, responseData['message']+"  歡迎：$username");
        }
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          MessageService.showMessage(context, "登入失敗");
        }
      }
    } catch (e) {
      if (mounted) {
        MessageService.showMessage(context, '$e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void register() async {
    try {
      isLoading = true;
      final responseData = await ApiService.postRequest('api/register/', {
        'email': emailController.text,
        'username': usernameController.text,
        'password': passwordController.text,
      });
      if (mounted) {
        MessageService.showMessage(context, responseData['message']);
      }
    } catch (e) {
      if (mounted) {
        MessageService.showMessage(context, '$e');
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint),
      obscureText: obscureText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('登入畫面')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            Text(
              "資工購物平台",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextInput(
              context: context,
              controller: emailController,
              label: '電子郵件',
            ),
            const SizedBox(height: 16),
            _buildTextInput(
              context: context,
              controller: usernameController,
              label: '使用者名稱(僅註冊需要)',
            ),
            const SizedBox(height: 16),
            _PasswordInput(
              controller: passwordController,
              label: '密碼',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary),
              ),
              child: const Text('登入'),
            ),
            const SizedBox(height: 32),
            TextButton(onPressed: register, child: const Text('註冊')),
            const SizedBox(height: 32),
            if (isLoading)
              CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
  }) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 14, color: theme.colorScheme.outline),
        prefixIcon: Icon(
          Icons.person_outline,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.onSurface, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      style: TextStyle(fontSize: 14),
    );
  }
}
class _PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const _PasswordInput({
    required this.controller,
    required this.label,
  });
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: 14, color: theme.colorScheme.outline),
        prefixIcon: Icon(Icons.lock_outline, size: 20, color: theme.colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.onSurface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      style: TextStyle(fontSize: 14),
    );
  }
}

