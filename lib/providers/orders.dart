import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../models/cart.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];
  List<Order> get items {
    return [..._items];
  }

  Future<void> fetchAndGetOrders() async {
    try {
      final response = await http.get(
        Uri.https(
            'flutter-update-a55eb-default-rtdb.asia-southeast1.firebasedatabase.app',
            '/orders.json'),
      );
      if (response.statusCode == 200) {
        _items = [];
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        data.forEach(
          (id, order) {
            _items.add(
              Order(
                id: id,
                amount: order['amount'],
                dateTime: DateTime.parse(order['dateTime']),
                products: (order['products'] as List<dynamic>)
                    .map((e) => Cart.fromjson(e))
                    .toList(),
              ),
            );
          },
        );
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> addItem(double amount, List<Cart> products) async {
    try {
      final timestamp = DateTime.now();
      final response = await http.post(
        Uri.https(
            'flutter-update-a55eb-default-rtdb.asia-southeast1.firebasedatabase.app',
            '/orders.json'),
        body: jsonEncode(
          {
            'amount': amount,
            'dateTime': timestamp.toIso8601String(),
            'products': products
                .map((product) => {
                      'id': product.id,
                      'title': product.title,
                      'quantity': product.quantity,
                      'price': product.price
                    })
                .toList(),
          },
        ),
      );
      if (response.statusCode == 200) {
        _items.insert(
          0,
          Order(
            id: jsonDecode(response.body)['name'],
            amount: amount,
            products: products,
            dateTime: timestamp,
          ),
        );
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> removeItem(String id) async {
    final response = await http.delete(
      Uri.https(
          'flutter-update-a55eb-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/orders/$id.json'),
    );
    if (response.statusCode == 200) {
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }
}
