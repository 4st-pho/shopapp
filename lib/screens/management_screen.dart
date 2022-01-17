import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/management_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/add_product_screen.dart';

class ManagementScreen extends StatelessWidget {
  static const routeName = '/management-screen';
  const ManagementScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prooduct management'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName).then(
                (value) {
                  if (value == true) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add success'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: _products.items[index],
          child: const ManagementItem(),
        ),
        itemCount: _products.items.length,
      ),
    );
  }
}
