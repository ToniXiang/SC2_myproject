import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  ProductListScreenState createState()=>ProductListScreenState();
}
class ProductListScreenState extends State<ProductListScreen>{
  late Future<List<Map<String, dynamic>>> _productsFuture;
  final storage = FlutterSecureStorage();
  final Set<int> selectedProducts = {};
  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final url = Uri.parse('http://192.168.1.111:8000/api/products/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((product) {
          return {
            'name': product['name'],
            'price': product['price'],
            'quantity': product['quantity'] ?? 1,
          };
        }).toList();
      } else {
        throw Exception('載入商品失敗: ${response.body}');
      }
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
      final orderData = jsonEncode({'products': selectedItems});
      final response = await http.post(
        Uri.parse('http://192.168.1.111:8000/api/orders/'),
        headers: {'Content-Type': 'application/json',
                  'Authorization': 'Token $token',},
        body: orderData,
      );
      showSnackBar((response.statusCode == 201?"訂單送出成功":"訂單送出失敗"));
    } catch (e) {
      showSnackBar("伺服器內部錯誤");
    }
    setState(() {
      for (var index in selectedProducts) {
        products[index]['quantity'] = 1;
      }
      selectedProducts.clear();
    });
}
  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("商品", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isSelected = selectedProducts.contains(index);
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
                        selectedProducts.remove(index);
                      } else {
                        selectedProducts.add(index);
                      }
                    });
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: placeOrder,
        child: const Icon(Icons.check),
      ),
    );
  }
}