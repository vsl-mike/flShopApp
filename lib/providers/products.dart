import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Future<void> toggleFavorite(String token, String userID) async {
    bool changeFavorite = !isFavorite;
    isFavorite = changeFavorite;
    String url = 'https://flutter-demob.firebaseio.com/favorites/' +
        userID +
        '/' +
        id +
        '.json?auth=' +
        token;
    var bodyJson = json.encode({
      'isFavorite': changeFavorite,
    });
    try {
      var response = await http.put(url, body: bodyJson);
      if (response.statusCode >= 400) throw Exception;
      notifyListeners();
    } catch (error) {
      isFavorite = !changeFavorite;
      notifyListeners();
      throw error;
    }
  }

  Product({
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isFavorite = false,
  });
}

class Products with ChangeNotifier {
  final String token;
  final String userId;
  Products(this.token, this.userId);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get itemsFavorite {
    return [
      ..._items.where((elem) {
        return elem.isFavorite == true;
      }).toList()
    ];
  }

  Future<void> getItems(bool withOwner) async {
    _items = [];
    String favUrl = 'https://flutter-demob.firebaseio.com/favorites/' +
        userId +
        '.json?auth=' +
        token;
    String url = withOwner
        ? 'https://flutter-demob.firebaseio.com/products.json?auth=' +
            token +
            '&orderBy="owner"&equalTo="' +
            userId +
            '"'
        : 'https://flutter-demob.firebaseio.com/products.json?auth=' + token;
    try {
      var response = await http.get(url);
      var responseFav = await http.get(favUrl);
      if (json.decode(response.body) == null) {
        notifyListeners();
        return;
      }
      var itemsMap = json.decode(response.body) as Map<String, dynamic>;
      List<Product> itemList = [];
      if (response.statusCode >= 400) throw Exception;
      itemsMap.forEach((productId, productInfo) {
        itemList.add(
          Product(
            id: productId,
            description: productInfo['description'],
            imageUrl: productInfo['imageURL'],
            price: double.parse(productInfo['price']),
            title: productInfo['title'],
            isFavorite: json.decode(responseFav.body) == null ||
                    json.decode(responseFav.body)[productId] == null
                ? false
                : json.decode(responseFav.body)[productId]['isFavorite'] == null
                    ? false
                    : json.decode(responseFav.body)[productId]['isFavorite'],
          ),
        );
      });
      _items = itemList;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product getByID(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> updateItem(String productId, String title, String price,
      String description, String imageUrl, bool isFavorite) async {
    String url =
        'https://flutter-demob.firebaseio.com/products.json?auth=' + token;
    Product product = Product(
      id: productId,
      description: description,
      title: title,
      price: double.parse(price),
      imageUrl: imageUrl,
      isFavorite: isFavorite,
    );
    var bodyJson = json.encode({
      productId: {
        'owner': userId,
        'title': product.title,
        'description': product.description,
        'price': product.price.toString(),
        'imageURL': product.imageUrl,
      }
    });
    try {
      var response = await http.patch(url, body: bodyJson);
      if (response.statusCode >= 400) throw Exception;
      var elementIndex =
          _items.indexOf(_items.firstWhere((prod) => prod.id == productId));
      _items[elementIndex] = product;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(String title, String price, String description,
      String imageUrl, bool isFavorite) async {
    String url =
        'https://flutter-demob.firebaseio.com/products.json?auth=' + token;
    var bodyJson = json.encode({
      'owner': userId,
      'title': title,
      'price': price,
      'description': description,
      'imageURL': imageUrl,
    });
    try {
      var response = await http.post(url, body: bodyJson);
      Product item = Product(
        id: json.decode(response.body)['name'],
        description: description,
        title: title,
        price: double.parse(price),
        imageUrl: imageUrl,
        isFavorite: isFavorite,
      );
      _items.add(item);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String productId) async {
    String url = 'https://flutter-demob.firebaseio.com/products/' +
        productId +
        '.json?auth=' +
        token;
    try {
      var response = await http.delete(url);
      if (response.statusCode >= 400) throw Exception;
      _items.removeWhere((product) => productId == product.id);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
