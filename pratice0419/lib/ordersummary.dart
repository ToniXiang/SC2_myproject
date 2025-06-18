import 'package:flutter/material.dart';

class OrderSummaryScreen extends StatelessWidget {
  final Set<int> selectedProducts;
  final Future<List<Map<String, dynamic>>> productsFuture;
  const OrderSummaryScreen({
    super.key,
    required this.selectedProducts,
    required this.productsFuture,
  });
  Widget _buildDivider(int index) => Divider(color: index % 2 == 0 ? Colors.blue : Colors.green);
  @override
  Widget build(BuildContext context) {
    if (selectedProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("訂單摘要空無一物", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("請選擇商品", style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final products = snapshot.data!;
          final selectedItems = selectedProducts.map((index) => products[index]).toList();
          double total = selectedItems.fold(0, (sum, product) {
            return sum + double.parse(product['price']) * product['quantity'];
          });
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return _buildDivider(index);
                  },
                  itemCount: selectedItems.length,
                  itemBuilder: (context, index) {
                    final product = selectedItems[index];
                    total += double.parse(product['price']) * product['quantity'];
                    return ListTile(
                      title: Text(product['name']),
                      subtitle: Text('\$${product['price']} x ${product['quantity']}'),
                      trailing: Text('\$${(double.parse(product['price']) * product['quantity']).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '總共花費: \$${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }
      },
    )
    ;
  }
}