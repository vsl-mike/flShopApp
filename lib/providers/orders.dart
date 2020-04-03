import 'dart:convert';
import './cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

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

  Future<List<Order>> getItems() async {
    String url = 'https://flutter-demob.firebaseio.com/orders.json';
    try {
      _items=[];
      var response = await http.get(url);
      if(response.statusCode>=400) throw Exception;
      Map<String, dynamic> mapItems = json.decode(response.body);
      mapItems.forEach((k, v) {
        Map<String, dynamic> orderMap = v['orderList'];
        List<CartItem> listCartItems = [];
        orderMap.forEach((k, v) {
          listCartItems.add(CartItem(k, v['price'], v['quantity'], v['title']));
        });
        _items.add(
          Order(
            id: k,
            dateTime: DateTime.parse(v['dateTime']),
            totalPrice: v['totalPrice'],
            orderList: listCartItems,
          ),
        );
      });
      return _items;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, double totalPrice) async {
    String url = 'https://flutter-demob.firebaseio.com/orders.json';
    var mapCartItems = Map.fromIterable(cartItems,
        key: (item) => item.id,
        value: (item) => {
              'quantity': item.quantity,
              'title': item.title,
              'price': item.price,
            });
    var bodyJson = jsonEncode({
      'dateTime': DateTime.now().toString(),
      'totalPrice': totalPrice,
      'orderList': mapCartItems,
    });
    try {
      var responce = await http.post(url, body: bodyJson);
      String _id = json.decode(responce.body)['name'];
      _items.add(
        Order(
          dateTime: DateTime.now(),
          totalPrice: totalPrice,
          id: _id,
          orderList: cartItems,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
