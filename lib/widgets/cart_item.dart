import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../providers/carts.dart';

class CartItem extends StatelessWidget {
  final String productId;
  const CartItem({required this.productId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(_cart.id),
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_){
        Provider.of<Carts>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                child: Text('\$${_cart.price * _cart.quantity}'),
              ),
            ),
          ),
          title: Text(_cart.title),
          subtitle: Text('\$${_cart.price}'),
          trailing: Text('${_cart.quantity}x'),
        ),
      ),
    );
  }
}
