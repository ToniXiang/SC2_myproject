import 'login_page.dart';
import 'product_list.dart';
import 'order_history.dart';
import 'settings_page.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key,required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首頁", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '資工購物平台',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '歡迎, $username',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('首頁'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('商品'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductListScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('訂單'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('登出'),
                    onTap: () {
                      showDialog(
                        context:context,
                        builder:(BuildContext context){
                          return AlertDialog(
                            title: const Text('登出'),
                            content: const Text('確定要登出嗎?'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('確定'),
                                onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                  Navigator.of(context).pop();
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
                        }
                      );        
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('設定'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage()
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('歡迎來到首頁!'),
      ),
    );
  }
}
