import 'package:flutter/material.dart';
import '../widgets/manage_view.dart';
import '../widgets/drawer.dart';

class ManageProductsScreen extends StatelessWidget {
  static const String routeName = '/manage-products';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
      ),
      drawer: AppDrawer(),
      body: ManageView()
    );
  }
}
