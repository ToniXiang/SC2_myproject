import 'package:pratice0419/presentation/presentation.dart';
import 'package:pratice0419/data/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState()=>LoginPageState();
}
class LoginPageState extends State<LoginPage>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  bool isLoading=false;
  void login() async {
    try{
      setState((){
        isLoading=true;
      });      
      final responseData = await ApiService.postRequest(
        'api/login/',
        {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      if(responseData.containsKey('token') && responseData.containsKey('username')) {
        String token = responseData['token'] ?? "未知Token";
        String username = responseData['username'] ?? "未知使用者";
        await saveToken(token);
        if (mounted) {
          MessageService.showMessage(context, "登入成功，歡迎 $username");
        }
        setState((){
          isLoading=false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      else{
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
        setState((){
          isLoading=false;
        });
        if (mounted) {
          MessageService.showMessage(context, "登入失敗");
        }
      }
    }
    catch(e){
      if (mounted) {
        MessageService.showMessage(context, "無法連接到伺服器");
      }
      setState((){
        isLoading=false;
      });
    }
  }
  void register() async {
    try {
      isLoading = true;
      final responseData = await ApiService.postRequest(
        'api/register/',
        {
          'email': emailController.text,
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );
      String feedback = responseData['message'] ?? responseData['error'] ?? "未知錯誤";
      if (mounted) {
        MessageService.showMessage(context, feedback);
      }
    } catch (e) {
      if (mounted) {
        MessageService.showMessage(context, "無法連接到伺服器");
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('登入畫面'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
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
