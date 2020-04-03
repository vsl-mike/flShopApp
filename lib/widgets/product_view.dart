import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../screens/product_detail.dart';

class ProductView extends StatefulWidget {
  final bool isFavorite;
  ProductView(this.isFavorite);
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  void goToProductDetail(BuildContext context, Product product) {
    Navigator.of(context)
        .pushNamed(ProductDetailScreen.routeName, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context, listen: false);
    List<Product> products = widget.isFavorite
        ? Provider.of<Products>(context).itemsFavorite
        : Provider.of<Products>(context).items;
    return products.length == 0
        ? Center(
            child: Text('No products'),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: products[index],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GridTile(
                    child: GestureDetector(
                      child: Image.network(
                        products[index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                      onTap: () => goToProductDetail(context, products[index]),
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black87,
                      title: Text(
                        products[index].title,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      leading: IconButton(
                        color: Theme.of(context).accentColor,
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () {
                          cart.addCartItem(
                            products[index].id,
                            products[index].price,
                            products[index].title,
                          );
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added product !'),
                              action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    cart.undoAdding(products[index].id);
                                  }),
                              duration: Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                        },
                      ),
                      trailing: Consumer<Product>(
                        builder: (ctx, product, _) => IconButton(
                          color: Theme.of(context).accentColor,
                          icon: product.isFavorite
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border),
                          onPressed: () => setState(
                            () {
                              product.toggleFavorite().catchError(
                                (_) {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Something went wrong!'),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
