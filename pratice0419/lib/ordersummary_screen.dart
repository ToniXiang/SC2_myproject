import 'package:flutter/material.dart';

class OrderSummaryScreen extends StatelessWidget {
  final Set<int> selectedProducts;
  final Future<List<Map<String, dynamic>>> productsFuture;
  const OrderSummaryScreen({
    super.key,
    required this.selectedProducts,
    required this.productsFuture,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("訂單摘要", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('沒有選擇任何商品'));
          } else {
            final products = snapshot.data!;
            final selectedItems = selectedProducts.map((index) => products[index]).toList();
            final totalCost = selectedItems.fold<double>(
              0,
              (sum, product) => sum + (double.parse(product['price']) * product['quantity']),
            );
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedItems.length,
                    itemBuilder: (context, index) {
                      final product = selectedItems[index];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Text('數量: ${product['quantity']}'),
                        trailing: Text('\$${(double.parse(product['price']) * product['quantity']).toInt()}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '總共花費: \$${totalCost.toInt()}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}