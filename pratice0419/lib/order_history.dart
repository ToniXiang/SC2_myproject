import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});
  @override
  OrderHistoryScreenState createState() => OrderHistoryScreenState();
}
class OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _orderHistoryFuture;
  final storage = const FlutterSecureStorage();
  Future<List<Map<String, dynamic>>> fetchOrderHistory() async {
    final url = Uri.parse('https://sc2-myproject.onrender.com/api/orders/');
    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.get(url,
        headers:{
          'Authorization': 'Token $token',
        });
      if (response.statusCode == 200) {
        final List<dynamic> orders = jsonDecode(response.body);
        final List<dynamic> orderItems = orders.expand((order) => order['items']).toList();
        return orderItems.map((item) {
          return {
            'id': item['id'],
            'product_name': item['product_name'],
            'product_price': item['product_price'],
            'quantity': item['quantity'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load order history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching order history: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _orderHistoryFuture = fetchOrderHistory();
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
        title: const Text("訂單", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _orderHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No order history available.'));
          } else {
            final orderHistory = snapshot.data!;
            return ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID: ${order['id']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text('Product: ${order['product_name']}'),
                        Text('Price: \$${double.parse(order['product_price'].toString()).toStringAsFixed(2)}'),
                        Text('Quantity: ${order['quantity']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
