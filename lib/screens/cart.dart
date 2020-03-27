import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.black12,
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 25),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$' + cart.getTotalPrice().toStringAsFixed(2),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'ORDER NOW',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: FittedBox(
                            child: Text(
                              '\$' +
                                  cart.items.values
                                      .toList()[index]
                                      .price
                                      .toStringAsFixed(2),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                            ),
                          ),
                        ),
                      ),
                      title: Text(cart.items.values.toList()[index].title,
                          style: TextStyle(fontSize: 20)),
                      subtitle: Text(
                        'total price:   \$' +
                            (cart.items.values.toList()[index].price *
                                    cart.items.values.toList()[index].quantity)
                                .toStringAsFixed(2),
                      ),
                      trailing: Text(
                        'x' +
                            cart.items.values
                                .toList()[index]
                                .quantity
                                .toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
