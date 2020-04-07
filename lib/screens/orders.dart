import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/orders_view.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../providers/auth.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false)
            .getItems(Provider.of<Auth>(context, listen: false).token),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error == null) {
              List<Order> orders = snapshot.data as List<Order>;
              return orders.length == 0
                  ? Center(
                      child: Text('No orders'),
                    )
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (ctx, index) {
                        return OrdersView(index);
                      },
                    );
            } else {
              return Center(
                child: Text('Something went wrong'),
              );
            }
          }
        },
      ),
    );
  }
}
