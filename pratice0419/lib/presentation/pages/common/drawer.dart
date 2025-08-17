import 'package:pratice0419/presentation/presentation.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  void logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('登出'),
          content: const Text('確定要登出嗎?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('確定'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text(
              'Menu',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('首頁'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('設定'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('登出', style: TextStyle(color: Colors.red)),
            onTap: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}