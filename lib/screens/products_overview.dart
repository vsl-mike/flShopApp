import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_icon.dart';
import '../providers/products.dart';
import '../widgets/product_view.dart';
import '../widgets/drawer.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    print('build Overview');
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
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false).getItems(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error == null) {
              return ProductView(isFavorite);
            } else {
              return Center(
                child: Text('Somethig went wrong!'),
              );
            }
          }
        },
      ),
    );
  }
}
