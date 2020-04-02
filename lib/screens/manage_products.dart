import 'package:flutter/material.dart';
import '../widgets/manage_view.dart';
import '../widgets/drawer.dart';
import '../screens/editing_product.dart';

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
                  Navigator.of(context).pushNamed(EditProduct.routeName,arguments: 'null');
                }),
          ],
        ),
        drawer: AppDrawer(),
        body: ManageView());
  }
}
