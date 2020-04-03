import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> func(Orders orders, Cart cart, double totalPrice) async {
    if (cart.items.length != 0) {
      List<CartItem> cartItems = cart.items.values.toList();
      setState(() {
        isLoading = true;
      });
      try {
        await orders.addOrder(cartItems, totalPrice);
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        throw error;
      }
      cart.clear();
      setState(() {
        isLoading = false;
      });
    }
  }

  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    Orders orders = Provider.of<Orders>(context, listen: false);
    var totalPrice = cart.getTotalPrice();
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
                      '\$' + totalPrice.toStringAsFixed(2),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ),
                isLoading
                    ? FlatButton(
                        child: Text(
                          'ORDER NOW',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: null,
                        disabledTextColor: Colors.grey,
                      )
                    : FlatButton(
                        child: Text(
                          'ORDER NOW',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () =>
                            func(orders, cart, totalPrice).catchError((_) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              content: Text('Something went wrong!'),
                              title: Text('Error'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: Text('Okay'),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
              ],
            ),
          ),
          isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        key: ValueKey(cart.items.values.toList()[index].id),
                        confirmDismiss: (direction) {
                          return showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  titlePadding: EdgeInsets.all(0),
                                  title: Container(
                                    padding: EdgeInsets.all(15),
                                    color: Theme.of(context).primaryColor,
                                    //width: double.infinity,
                                    child: Text(
                                      'Are you sure ?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  content: Text(
                                    'Delete item ?',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Yes'),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('No'),
                                    ),
                                  ],
                                );
                              });
                        },
                        background: Container(
                          child: Icon(
                            Icons.delete,
                            size: 40,
                            color: Colors.white,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          color: Theme.of(context).errorColor,
                        ),
                        onDismissed: (direction) {
                          cart.deleteCartItem(cart.items.keys.toList()[index]);
                        },
                        child: Card(
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
                              title: Text(
                                  cart.items.values.toList()[index].title,
                                  style: TextStyle(fontSize: 20)),
                              subtitle: Text(
                                'total price:   \$' +
                                    (cart.items.values.toList()[index].price *
                                            cart.items.values
                                                .toList()[index]
                                                .quantity)
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
