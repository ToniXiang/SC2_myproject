import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pratice0419/presentation/presentation.dart';
import 'package:pratice0419/data/data.dart';

class ClassificationPage extends StatefulWidget {
  const ClassificationPage({super.key});
  @override
  ClassificationPageState createState() => ClassificationPageState();
}

class ClassificationPageState extends State<ClassificationPage> {
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
      final data = await ApiService.getRequest('api/products/');
      return data.map<Map<String, dynamic>>((product) {
        return {
          'name': product['name'] ?? '未命名商品',
          'price': product['price'] ?? 0,
          'quantity': product['quantity'] ?? 1,
        };
      }).toList();
    } catch (e) {
      throw Exception('取得商品列表失敗: $e');
    }
  }

  void placeOrder() async {
    if (selectedProducts.isEmpty) {
      if (!mounted) return;
      MessageService.showMessage(context, "未選取任何商品");
      return;
    }
    final products = await _productsFuture;
    final selectedItems =
        selectedProducts.map((index) {
          final product = products[index];
          return {
            'product_name': product['name'],
            'product_price': product['price'],
            'quantity': product['quantity'],
          };
        }).toList();
    try {
      final token = await storage.read(key: 'auth_token');
      await ApiService.postRequest('api/orders/', {
        'products': selectedItems,
      }, token: token);
      if (!mounted) return;
      MessageService.showMessage(context, "訂單送出成功");
    } catch (e) {
      if (!mounted) return;
      MessageService.showMessage(context, "訂單送出失敗");
      return;
    }
    setState(() {
      for (var index in selectedProducts) {
        products[index]['quantity'] = 1;
      }
      selectedProducts.clear();
    });
  }

  void pushOrder() async {
    final products = await _productsFuture;
    double total = 0;
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("訂單明細"),
          content: SingleChildScrollView(
            child: ListBody(
              children:
                  selectedProducts.map((index) {
                    final product = products[index];
                    total +=
                        double.parse(product['price']) * product['quantity'];
                    return ListTile(
                      title: Text(product['name']),
                      subtitle: Text('數量: ${product['quantity']}'),
                      trailing: Text(
                        '\$${(double.parse(product['price']) * product['quantity']).toStringAsFixed(2)}',
                      ),
                    );
                  }).toList(),
            ),
          ),
          actions: [
            Text("總共\$${total.toStringAsFixed(2)}"),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    placeOrder();
                    Navigator.of(context).pop();
                  },
                  child: const Text("送出"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("關閉"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void removeOrder() async {
    final products = await _productsFuture;
    setState(() {
      for (var product in products) {
        product['quantity'] = 1;
      }
      selectedProducts.clear();
    });
    if (!mounted) return;
    MessageService.showMessage(context, "刷新當前訂單完畢");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: HomeContent(
              productsFuture: _productsFuture,
              selectedProducts: selectedProducts,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DownOperations(
              onPushOrder: pushOrder,
              onRemoveOrder: removeOrder,
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          child: const Text("查看訂單明細", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: onRemoveOrder,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          child: const Text("清除訂單", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
