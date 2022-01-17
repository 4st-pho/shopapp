import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../providers/orders.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expand = true;

  @override
  Widget build(BuildContext context) {
    final _order = Provider.of<Order>(context, listen: false);
    final _orders = Provider.of<Orders>(context, listen: false);
    return Dismissible(
      key: ValueKey(_order.id),
      onDismissed: (_) {
        _orders.removeItem(_order.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        color: Colors.orange,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Card(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  _expand = !_expand;
                });
              },
              title: Text('\$${_order.amount}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(_order.dateTime),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _expand
                    ? const Icon(Icons.expand_more)
                    : const Icon(Icons.expand_less),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _expand ? 0 : 200,
              child: Container(
                child: Column(
                  children: [
                    ..._order.products
                        .map(
                          (product) => Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(children: [
                              Text(product.title),
                              const Spacer(),
                              Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 80),
                                  alignment: Alignment.centerLeft,
                                  child: Text('\$${product.price}')),
                              Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 30),
                                  alignment: Alignment.centerRight,
                                  child: Text('${product.quantity}x'))
                            ]),
                          ),
                        )
                        .toList()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
