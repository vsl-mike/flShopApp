import 'package:flutter/cupertino.dart';

class CartItem {
  String id;
  String title;
  int quantity;
  double price;

  CartItem(
    this.id,
    this.price,
    this.quantity,
    this.title,
  );
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double totalPrice;

  double getTotalPrice() {
    double totalPrice = 0.0;

    _items.forEach((k, v) {
      totalPrice += v.price * (v.quantity.toDouble());
    });

    return totalPrice;
  }

  int get cartLenght => _items.length;

  void addCartItem(String productId, double price, String title) {
    if (_items.containsKey(productId))
      _items.update(productId, (element) {
        return CartItem(
            element.id, element.price, element.quantity + 1, element.title);
      });
    else {
      _items.putIfAbsent(
        productId,
        () => CartItem(DateTime.now().toString(), price, 1, title),
      );
    }
    notifyListeners();
  }

  void undoAdding(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity > 1)
        _items.update(productId, (element) {
          return CartItem(
              element.id, element.price, element.quantity - 1, element.title);
        });
      else
        _items.remove(productId);
    } else
      return;
    notifyListeners();
  }

  void deleteCartItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
