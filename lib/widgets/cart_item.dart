import 'package:flutter/material.dart';
import '../providers/cart.dart';

class DissmisibleCartItem extends StatelessWidget {
  final Cart cart;
  final int index;
  DissmisibleCartItem({this.cart, this.index});
  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    'Are you sure ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
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
                        color: Theme.of(context).colorScheme.onBackground),
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
              'x' + cart.items.values.toList()[index].quantity.toString(),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
