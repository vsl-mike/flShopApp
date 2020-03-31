import 'package:flutter/material.dart';
import '../widgets/cart_icon.dart';
import '../widgets/product_view.dart';
import '../widgets/drawer.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("All"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Only Favorites"),
              ),
            ],
            onSelected: (index) {
              setState(() {
                if (index == 1)
                  isFavorite = false;
                else
                  isFavorite = true;
              });
            },
          ),
          CartIcon(),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductView(isFavorite),
    );
  }
}
