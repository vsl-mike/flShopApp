import 'package:flutter/material.dart';
import '../widgets/cart_icon.dart';
import '../widgets/product_view.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          CartIcon()
        ],
      ),
      body: ProductView(),
    );
  }
}
