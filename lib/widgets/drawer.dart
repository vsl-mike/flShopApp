import 'package:flutter/material.dart';
import 'package:newapp/screens/products_overview.dart';
import '../screens/orders.dart';
import '../screens/manage_products.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Fashion Moll'),
          ),
          ListTile(
            title: Text('Shop'),
            leading: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.credit_card),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            title: Text('Manage your products'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
