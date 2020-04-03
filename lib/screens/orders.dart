import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../widgets/orders_view.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void didChangeDependencies() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Orders>(context, listen: false).getItems().then((listOrders) {
        orders = listOrders;
        setState(() {
          isLoading = false;
        });
      }).catchError((_) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Error'),
                  content: Text('Something went wrong!'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Okay'),
                    ),
                  ],
                )).then((_) {
          setState(() {
            isLoading = false;
            orders=[];
          });
        });
      });
    }
    super.didChangeDependencies();
  }

  List<Order> orders;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, index) {
                return OrdersView(index);
              }),
    );
  }
}
