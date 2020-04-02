import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/editing_product.dart';

class ManageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).items;
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(products[index].imageUrl),
            ),
            title: Text(products[index].title),
            trailing: Container(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(EditProduct.routeName,
                            arguments: products[index].id);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {})
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
