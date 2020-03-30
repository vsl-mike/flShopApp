import './cart.dart';
import 'package:flutter/cupertino.dart';

class Order {
  final String id;
  final DateTime dateTime;
  final double totalPrice;
  final List<CartItem> orderList;

  Order({
    this.id,
    this.dateTime,
    this.orderList,
    this.totalPrice,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  void addOrder(List<CartItem> cartItems, double totalPrice) {
    _items.add(
      Order(
        dateTime: DateTime.now(),
        totalPrice: totalPrice,
        id: DateTime.now().toString(),
        orderList: cartItems,
      ),
    );
    notifyListeners();
  }
}
