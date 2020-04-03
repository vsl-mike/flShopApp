import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<void> addOrd(Orders orders, Cart cart, double totalPrice) async {
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
                            addOrd(orders, cart, totalPrice).catchError((_) {
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
                      return DissmisibleCartItem(
                        cart: cart,
                        index: index,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
