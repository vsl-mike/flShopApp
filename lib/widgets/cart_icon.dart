import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../screens/cart.dart';

class CartIcon extends StatelessWidget {
  void goToCartScreen(BuildContext context) {
    Navigator.of(context).pushNamed(CartScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToCartScreen(context),
      child: Stack(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => goToCartScreen(context),
            iconSize: 37,
          ),
          Consumer<Cart>(
            builder: (_, cart, __) {
              return cart.cartLenght == 0
                  ? SizedBox()
                  : Positioned(
                      top: 5,
                      left: 25,
                      height: 20,
                      width: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(
                          cart.cartLenght.toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
