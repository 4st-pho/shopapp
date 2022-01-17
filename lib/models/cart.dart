import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final int quantity;
  Cart(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
  factory Cart.fromjson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}
