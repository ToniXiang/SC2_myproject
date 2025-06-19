import 'home_page.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'notice_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState()=>LoginScreenState();
}
class LoginScreenState extends State<LoginScreen>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool isLoading=false;
  void showSnackBar(String message) {
    // 不紀錄登入或註冊的錯誤訊息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  void login() async {
    try{
      setState((){
        isLoading=true;
      });      
      final responseData = await ApiService.postRequest(
        'login/',
        {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      if(responseData.containsKey('token') && responseData.containsKey('username')) {
        String token = responseData['token'] ?? "未知Token";
        String username = responseData['username'] ?? "未知使用者";
        await saveToken(token);
        NoticeService.removeAllNotices();
        showSnackBar("登入成功，歡迎 $username");
        setState((){
          isLoading=false;
        }); 
        navigateToHomeScreen(username);
      }
      else{
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        setState((){
          isLoading=false;
        });
        showSnackBar("登入失敗");
      } 
    }
    catch(e){
      showSnackBar("無法連接到伺服器");
    }
  }
  void register() async {
    try {
      isLoading = true;
      final responseData = await ApiService.postRequest(
        'register/',
        {
          'email': emailController.text,
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );
      String feedback = responseData['message'] ?? responseData['error'] ?? "未知錯誤";
      showSnackBar(feedback);
    } catch (e) {
      showSnackBar("無法連接到伺服器");
    } finally {
      isLoading = false;
    }
  }
  void navigateToHomeScreen(String username) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('登入畫面'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "資工購物平台",
              style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            buildTextField(
              controller: emailController,
              label: '電子郵件',
              hint: '你的電子郵件',
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: usernameController,
              label: '使用者名稱',
              hint: '你的使用者名稱(登入不用寫)',
            ),
            const SizedBox(height: 16),
            buildTextField(
              controller: passwordController,
              label: '密碼',
              hint: '你的密碼',
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed:login,
              child: const Text('登入'),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed:register,
              child: const Text('註冊'),
            ),
            const SizedBox(height: 32),
            const Text("登入需要數十秒的等待時間"),
            if(isLoading)
              CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
