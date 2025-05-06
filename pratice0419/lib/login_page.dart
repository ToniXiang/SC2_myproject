import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  void login() async {
    String email=emailController.text;
    String password=passwordController.text;
    final url = Uri.parse('https://sc2-myproject.onrender.com/api/login/');
    try{
      setState((){
        isLoading=true;
      });      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final responseData = jsonDecode(response.body);
      if(response.statusCode==200){
        String token = responseData['token'] ?? "未知Token";
        String username = responseData['username'] ?? "未知使用者";
        saveToken(token);
        showSnackBar("登入成功，歡迎 $username");
        navigateToHomeScreen(username);
      }
      else{
        setState((){
          emailController.clear();
          usernameController.clear();
          passwordController.clear();
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
    String email=emailController.text;
    String username=usernameController.text;
    String password=passwordController.text;
    try{
      isLoading=true;
      final response = await http.post(
        Uri.parse('https://sc2-myproject.onrender.com/api/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email':email
        }),
      );
      final responseData = jsonDecode(response.body);
      if(!mounted)return;
      String feedback = responseData['message'] ?? responseData['error'] ?? "未知錯誤";
      showSnackBar(feedback);
    }
    catch(e){
      showSnackBar("無法連接到伺服器");
      isLoading=false;
    }
  }
  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      setState((){
        isLoading=false;
      });   
    }
  }
  void navigateToHomeScreen(String username) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: username),
        ),
      );
    }
  }
  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
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
            Text(
              "資工購物平台",
              style: const TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: '郵件',hintText:"你的電子郵件"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: '名稱',hintText:("你的名稱(登入不用寫)")),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: '密碼',hintText:("你的密碼")),
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
