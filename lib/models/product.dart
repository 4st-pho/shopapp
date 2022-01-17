import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool favorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.favorite = false});
  Future<void> toggleFavorite() async {
    final response = await http.patch(
      Uri.https(
          'flutter-update-a55eb-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/products/$id.json'),
      body: jsonEncode(
        {'favorite': !favorite},
      ),
    );
    if (response.statusCode == 200) {
      favorite = !favorite;
      notifyListeners();
    }
  }
}
