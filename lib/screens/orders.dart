import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/orders_view.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    Orders orders = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: orders.items.length,
          itemBuilder: (ctx, index) {
            return OrdersView(index);
          }),
    );
  }
}
