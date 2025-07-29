import 'login_page.dart';
import 'order_history_page.dart';
import 'settings_page.dart';
import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'order_summary_page.dart';
import '../../data/services/notice_service.dart';
import 'notice_page.dart';
import 'shopping_cart_page.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState()=>HomeScreenState();
}
class HomeScreenState extends State<HomeScreen>{
  late Future<List<Map<String, dynamic>>> _productsFuture;
  final storage = FlutterSecureStorage();
  final Set<int> selectedProducts = {};
  int selectedPageIndex = 0;
  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final data = await ApiService.getRequest('products/');
      return data.map((product) {
        return {
          'name': product['name'],
          'price': product['price'],
          'quantity': product['quantity'] ?? 1,
        };
      }).toList();
    } catch (e) {
      throw Exception('伺服器內部錯誤');
    }
  }
  void placeOrder() async {
    if (selectedProducts.isEmpty){
      if (!mounted) return;
      NoticeService.showSnackBar("未選取任何商品",context);
      return;
    }
    final products = await _productsFuture;
    final selectedItems = selectedProducts.map((index) {
    final product = products[index];
      return {
        'product_name': product['name'],
        'product_price': product['price'],
        'quantity': product['quantity'],
      };
    }).toList();
    try {
      final token = await storage.read(key: 'auth_token');
      await ApiService.postRequest(
        'orders/',
        {'products': selectedItems},
        token: token,
      );
      if (!mounted) return;
      NoticeService.showSnackBar("訂單送出成功",context);
    } catch (e) {
      if(!mounted) return;
      NoticeService.showSnackBar("訂單送出失敗",context);
      return;
    }
    setState(() {
      for (var index in selectedProducts) {
        products[index]['quantity'] = 1;
      }
      selectedProducts.clear();
    });
  }
  void pushOrder()async{
    final products = await _productsFuture;
    double total=0;
    if (!mounted) return;
    showDialog(
      context:context,
      builder:(BuildContext context){
        return AlertDialog(
          title:const Text("訂單明細"),
          content:SingleChildScrollView(
            child: ListBody(
              children: selectedProducts.map((index) {
                final product = products[index];
                total+=double.parse(product['price'])*product['quantity'];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('數量: ${product['quantity']}'),
                  trailing: Text('\$${(double.parse(product['price'])*product['quantity']).toStringAsFixed(2)}'),
                );
            }).toList(),
          ),
          ),
          actions:[
            Text("總共\$${total.toStringAsFixed(2)}"),
            Row(
              children:[
                ElevatedButton(
                  onPressed:(){
                    placeOrder();
                    Navigator.of(context).pop();
                  },
                  child:const Text("送出")
                ),
                TextButton(
                  onPressed:(){
                    Navigator.of(context).pop();
                  },
                  child:const Text("關閉")
                ),
            ])
          ]
        );
      }
    );
  }
  void removeOrder()async{
    final products = await _productsFuture;
    setState(() {
      for (var product in products) {
        product['quantity'] = 1;
      }
      selectedProducts.clear();
    });
    if (!mounted) return;
    NoticeService.showSnackBar("刷新當前訂單完畢",context);
  }
  void openShoppingCart(){
    setState(() {
      selectedPageIndex = 0;
    });
  }
  void openOrderSummary(){
    setState(() {
      selectedPageIndex = 1;
    });
  }
  void openNotice(){
    setState(() {
      selectedPageIndex = 2;
    });
  }
  void logOut(){
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
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
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
        }
      );        
  }
  
  void openSettingsPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(),
      ),
    );
    setState(() {
      // Refresh the state after returning from settings
    });
  }
  Widget getPageContent() {
    switch (selectedPageIndex) {
      case 0:
        return HomeContent(
          productsFuture: _productsFuture,
          selectedProducts: selectedProducts,
        );
      case 1:
        return OrderSummaryScreen(
          productsFuture: _productsFuture,
          selectedProducts: selectedProducts,
        );
      case 2:
        return const NoticePage(); 
      default:
        return const Center(
          child: Text('未知頁面'),
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首頁", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent,
        bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          color: Colors.deepPurpleAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: selectedPageIndex == 0 ? Colors.amber : Colors.white,
                    ),
                    onPressed: openShoppingCart,
                  ),
                  Text(
                    "購物車",
                    style: TextStyle(
                      color: selectedPageIndex == 0 ? Colors.amber : Colors.white,
                      fontSize: 12),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.book,
                      color: selectedPageIndex == 1 ? Colors.amber : Colors.white,
                    ),
                    onPressed: openOrderSummary,
                  ),
                  Text(
                    "當前訂單",
                    style: TextStyle(
                      color: selectedPageIndex == 1 ? Colors.amber : Colors.white,
                      fontSize: 12),
                  ),
                ],
              ),
              if(NoticeService.isNoticeEnabled)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: selectedPageIndex == 2 ? Colors.amber : Colors.white,
                    ),
                    onPressed: openNotice,
                  ),
                  Text(
                    "操作紀錄",
                    style: TextStyle(
                      color: selectedPageIndex == 2 ? Colors.amber : Colors.white,
                      fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 150,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '資工購物平台',
                            style: TextStyle(
                              fontSize: 20,
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
                      Navigator.pop(context);
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
                    onTap: logOut,
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('設定'),
                    onTap: openSettingsPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body:getPageContent(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child:  selectedPageIndex != 2
          ? DownOperations(
            onPushOrder: pushOrder,
            onRemoveOrder: removeOrder,
            )
          : const SizedBox(height: 0, width: 0)
      ),
    );
  }
}
class DownOperations extends StatelessWidget {
  final VoidCallback onPushOrder;
  final VoidCallback onRemoveOrder;

  const DownOperations({
    super.key,
    required this.onPushOrder,
    required this.onRemoveOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onPushOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          child: const Text(
            "查看訂單明細",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: onRemoveOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          child: const Text(
            "清除訂單",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
