import 'package:flutter/material.dart';
import './providers/auth.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/products_overview.dart';
import './screens/product_detail.dart';
import './screens/cart.dart';
import './providers/orders.dart';
import './screens/orders.dart';
import './screens/manage_products.dart';
import './screens/editing_product.dart';
import './screens/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previosProd) {
            return Products(auth.token, auth.userID);
          },
          create: (ctx) {
            return Products('', '');
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (_, auth, _child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            routes: {
              '/': (ctx) =>
                  auth.isAuth() ? ProductsOverviewScreen() : AuthScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
              EditProduct.routeName: (ctx) => EditProduct(),
            },
          );
        },
      ),
    );
  }
}
