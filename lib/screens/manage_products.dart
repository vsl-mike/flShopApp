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
      body: FutureBuilder(
        future: Provider.of<Products>(context, listen: false).getItems(true),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            if (snapshot.error == null)
              return ManageView();
            else {
              return Center(child: Text('Something wen\'t wrong!'));
            }
          }
        },
      ),
    );
  }
}
