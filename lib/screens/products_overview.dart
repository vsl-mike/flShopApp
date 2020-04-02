import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_icon.dart';
import '../providers/products.dart';
import '../widgets/product_view.dart';
import '../widgets/drawer.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isFavorite = false;
  bool isInit = false;
  @override
  void didChangeDependencies() {
    if (!isInit) {
      Provider.of<Products>(context).getItems().catchError((error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Can\'t upload products'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed('/');
                        },
                        child: Text('Try again!'))
                  ],
                ));
      }).then((_) {
        setState(() {
          isInit = true;
        });
      });
    }
    super.didChangeDependencies();
  }

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
      body: !isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductView(isFavorite),
    );
  }
}
