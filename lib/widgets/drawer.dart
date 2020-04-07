import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/orders.dart';
import '../screens/manage_products.dart';
import '../providers/auth.dart';

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
              Navigator.of(context).pushReplacementNamed('/');
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
           ListTile(
            title: Text('LogOut'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              Navigator.of(context).pop();
              await Provider.of<Auth>(context,listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
              //Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
