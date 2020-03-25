import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../models/product.dart';
import '../screens/product_detail.dart';

class ProductView extends StatelessWidget {
  void goToProductDetail(BuildContext context, Product product) {
    Navigator.of(context)
        .pushNamed(ProductDetailScreen.routeName, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ClipRRect(
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
                icon: Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              trailing: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {},
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
