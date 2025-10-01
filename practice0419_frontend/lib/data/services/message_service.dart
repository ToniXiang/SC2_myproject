import 'package:practice0419_frontend/data/data.dart';
import 'package:practice0419_frontend/presentation/presentation.dart';

class MessageService {
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  static Future<void> removeToken() async {
  await AuthService.logout();
  }
  static void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.logout, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text('登出', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          content: const Text('確定要登出嗎?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                MessageService.removeToken();
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('登出'),
            ),
          ],
        ),
  );
}
}
