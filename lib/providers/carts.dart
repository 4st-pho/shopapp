import 'package:flutter/foundation.dart';
import '../models/cart.dart';

class Carts with ChangeNotifier {
  Map<String, Cart> _items = {};
  Map<String, Cart> get items {
    return {..._items};
  }

  int count() {
    var count = 0;
    _items.forEach((key, value) {
      count += value.quantity;
    });
    return count;
  }

  double totalAmount() {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (oldValue) => Cart(
            id: oldValue.id,
            title: oldValue.title,
            price: oldValue.price,
            quantity: oldValue.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => Cart(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void removeSingleItem(String key) {
    if (_items.containsKey(key)) {
      if (_items[key]!.quantity > 1) {
        _items.update(
          key,
          (oldValue) => Cart(
              id: oldValue.id,
              title: oldValue.title,
              price: oldValue.price,
              quantity: oldValue.quantity - 1),
        );
      } else {
        removeItem(key);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
