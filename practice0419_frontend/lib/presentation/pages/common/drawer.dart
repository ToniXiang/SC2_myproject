import 'package:practice0419_frontend/presentation/presentation.dart';
import 'package:practice0419_frontend/data/data.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlutterLogo(size: 64),
                  Text(
                    '資工購物平台',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('首頁'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('分類'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ClassificationPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('訂單紀錄'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => OrderHistoryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('個人中心'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('設定'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('幫助'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => HelperPage()));
            },
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              '登出',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
void removeToken() async {
  await AuthService.logout();
}
void showLogoutDialog(BuildContext context) {
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
                removeToken();
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
