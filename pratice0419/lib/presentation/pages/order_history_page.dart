import 'package:pratice0419/presentation/presentation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pratice0419/data/data.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late Future<List<dynamic>> _ordersFuture;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<dynamic>> fetchOrders() async {
    try {
      final token = await storage.read(key: 'auth_token');
      final data = await ApiService.getRequest('api/orders/', token: token);
      return data;
    } catch (e) {
      throw Exception('取得訂單失敗');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("錯誤: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("目前沒有任何訂單"));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order['id'];
              final createdAt = DateTime.parse(order['created_at']);
              final items = order['items'] as List<dynamic>;

              double total = 0;
              for (var item in items) {
                total += double.parse(item['product_price']) * item['quantity'];
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ExpansionTile(
                  leading: const Icon(Icons.receipt_long),
                  collapsedBackgroundColor: theme.colorScheme.surface,
                  backgroundColor: theme.colorScheme.surface,
                  title: Text("訂單 #$orderId"),
                  subtitle: Text(
                    "建立於 ${createdAt.toLocal()}".split(".")[0],
                  ),
                  children: [
                    Column(
                      children: items.map((item) {
                        return ListTile(
                          title: Text(item['product_name']),
                          subtitle: Text("數量: ${item['quantity']}"),
                          trailing: Text(
                            "\$${(double.parse(item['product_price']) * item['quantity']).toStringAsFixed(2)}",
                          ),
                        );
                      }).toList(),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("總計: \$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }
}
