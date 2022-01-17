import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(Uri.https(
          'flutter-update-a55eb-default-rtdb.asia-southeast1.firebasedatabase.app',
          'products.json'));
      if (response.body.isEmpty) {
        return;
      }
      if (response.statusCode == 200) {
        _items = [];
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        data.forEach((id, value) {
          _items.add(Product(
            id: id,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            favorite: value['favorite'],
          ));
        });
        notifyListeners();
      }
    } catch (error) {
     HttpException(error.toString());
    }
  }

  List<Product> get itemsFavorite {
    return items.where((element) => element.favorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      Product temp = _items[index];
      _items.removeAt(index);
      notifyListeners();
      final response = await http.delete(
        Uri.https(
            'flutter-update-a55eb-default-rtdb.asia-southeast1.firebasedatabase.app',
            '/products/$id.json'),
      );
      if (response.statusCode >= 400) {
        _items.insert(index, temp);
        notifyListeners();
      }
    }
  }

  Future<void> addProduct(
      String title, String description, double price, String imageUrl) async {
    try {
      final response = await http.post(
          Uri.https(
              'flutter-update-a55eb-default-rtdb.asia-southeast1.firebasedatabase.app',
              'products.json'),
          body: jsonEncode({
          'title': title,
            'description': description,
            'price': price,
            'imageUrl': imageUrl,
            'favorite': false,
          }));
      if (response.statusCode == 200) {
        _items.add(
          Product(
              id: jsonDecode(response.body)['name'],
              title: title,
              description: description,
              price: price,
              imageUrl: imageUrl),
        );
        notifyListeners();
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final response = await http.patch(
          Uri.https(
              'flutter-update-a55eb-default-rtdb.asia-southeast1.firebasedatabase.app',
              '/products.json'),
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      _items[index] = product;
      notifyListeners();
    }
  }
}
