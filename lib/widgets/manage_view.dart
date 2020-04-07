import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/editing_product.dart';

class ManageView extends StatelessWidget {
  Future<void> tryToDelete(BuildContext context, String productId) async {
    Provider.of<Products>(context, listen: false)
        .deleteProduct(productId)
        .then((_) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Item delete!',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Can\'t delete, something went wrong'),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Try again',
            onPressed: () => tryToDelete(context, productId),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).items;
    return products.length == 0
        ? Center(
            child: Text('No your products'),
          )
        : ListView.builder(
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
                              Navigator.of(context).pushNamed(
                                  EditProduct.routeName,
                                  arguments: products[index].id);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              tryToDelete(context, products[index].id);
                            })
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
