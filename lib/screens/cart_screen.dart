import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carts.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final _carts = Provider.of<Carts>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Amount'),
                  const Spacer(),
                  Chip(
                    label: Text('\$${_carts.totalAmount()}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextButton(
                      onPressed: (_carts.totalAmount() <= 0 || _loading == true)
                          ? null
                          : () async {
                              setState(() {
                                _loading = true;
                              });
                              await Provider.of<Orders>(context, listen: false)
                                  .addItem(
                                _carts.totalAmount(),
                                _carts.items.values.toList(),
                              )
                                  .then((_) {
                                setState(() {
                                  _loading = false;
                                  _carts.clear();
                                });
                              });
                            },
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text('Order all'),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: _carts.items[_carts.items.keys.toList()[index]],
              child: CartItem(
                productId: _carts.items.keys.toList()[index],
              ),
            ),
            itemCount: _carts.items.length,
          ))
        ],
      ),
    );
  }
}
