import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndGetOrders(),
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (data.error != null) {
              return const Center(
                child: Text(
                  'error',
                  style: TextStyle(color: Colors.red, fontSize: 40),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: _orders.items.length,
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  value: _orders.items[index],
                  child: const OrderItem(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
