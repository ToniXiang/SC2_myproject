import 'login_page.dart';
import 'order_history.dart';
import 'settings_page.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'ordersummary_screen.dart';
class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key,required this.username});
  @override
  HomeScreenState createState()=>HomeScreenState();
}
class HomeScreenState extends State<HomeScreen>{
  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
  late Future<List<Map<String, dynamic>>> _productsFuture;
  final storage = FlutterSecureStorage();
  final Set<int> selectedProducts = {};
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
      showSnackBar("未選取任何商品");
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
      showSnackBar("訂單送出成功");
    } catch (e) {
      showSnackBar("訂單送出失敗");
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
    // await _Future; 並不會重新發起 HTTP 請求，而是直接返回已解析的結果
    final products = await _productsFuture;
    setState(() {
      for (var index in selectedProducts) {
        products[index]['quantity'] = 1;
      }
      selectedProducts.clear();
    });
    showSnackBar("刷新當前訂單完畢");
  }
  void openOrderSummary(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryScreen(
          selectedProducts: selectedProducts,
          productsFuture: _productsFuture,
        ),
      ),
    );
  }
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
                          '歡迎, ${widget.username}!',
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
      body: HomeContent(
        productsFuture: _productsFuture,
        selectedProducts: selectedProducts,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
          icon: const Icon(Icons.remove),
          label: "清除訂單",
          ),
          BottomNavigationBarItem(
          icon: const Icon(Icons.book),
          label: "檢查訂單",
          ),
          BottomNavigationBarItem(
          icon: const Icon(Icons.check),
          label: "送出訂單",
          ),
        ],onTap: (index) {
          switch(index){
            case 0:
              removeOrder();
              break;
            case 1:
              openOrderSummary();
              break;
            case 2:
              pushOrder();
              break;
            default:
              break;
          }
        },
      )
    );
  }
}
class HomeContent extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> productsFuture;
  final Set<int> selectedProducts;
  const HomeContent({super.key, required this.productsFuture, required this.selectedProducts});
  @override
  State<HomeContent> createState() => HomeContentState();
}
class HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('沒有任何商品內容'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isSelected = widget.selectedProducts.contains(index);
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('\$${double.parse(product['price'].toString()).toStringAsFixed(2)}'),
                  leading: Icon(
                    isSelected ? Icons.check : Icons.shopping_cart,
                    color: isSelected ? Colors.green : null,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (product['quantity'] > 1) {
                              product['quantity']--;
                            }
                          });
                        },
                      ),
                      Text(product['quantity'].toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            product['quantity']++;
                          });
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        products[index]['quantity']=1;
                        widget.selectedProducts.remove(index);
                      } else {
                        widget.selectedProducts.add(index);
                      }
                  });
                },
              );
            },
          );
        }
      },
    );
  }
}
