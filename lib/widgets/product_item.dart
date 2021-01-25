import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Consumer<Product>(
      builder: (c, product, _) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ctx) => ProductDetailScreen(title),
                //   ),
                // );
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routName,
                  arguments: product.id,
                );
              },
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              leading: IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () => product.toggleFavoriteStatus(
                    authData.token, authData.userId),
                color: Color.fromRGBO(255, 0, 0, 1),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: InkWell(
                child: IconButton(
                  icon: Container(
                    child: Icon(Icons.shopping_cart),
                  ),
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Added Item to Cart!',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 3),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ));
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
      ),
      // child: Text(
      //   'Never changes!',
      //   style: TextStyle(color: Colors.black),
      // ),
    );
  }
}
