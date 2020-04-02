import 'package:flutter/material.dart';
import '../widgets/manage_view.dart';
import '../widgets/drawer.dart';
import '../screens/editing_product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ManageProductsScreen extends StatelessWidget {
  static const String routeName = '/manage-products';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: 'null');
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Products>(context, listen: false)
            .getItems()
            .catchError((error) {
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
        }),
        child: ManageView(),
      ),
    );
  }
}
