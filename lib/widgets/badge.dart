import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';

class Badge extends StatelessWidget {
  final String quantity;
  const Badge({required this.quantity, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    void _selectPage() {
      Navigator.of(context).pushNamed(CartScreen.routeName);
    }

    return Stack(
      children: [
        IconButton(
            onPressed: () => _selectPage(),
            icon: const Icon(Icons.shopping_cart_outlined)),
        Positioned(
            top: 8,
            right: 8,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(5),
                ),
                constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
                child: Text(quantity))),
      ],
    );
  }
}
