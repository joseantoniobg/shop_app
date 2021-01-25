import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routName = '/product-detail';

  ProductDetailScreen();
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(id);
    return Scaffold(
      backgroundColor: Colors.grey,
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.purple[50],
                    Colors.purple[600],
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [.4, .8, 1],
                )),
                padding: EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.all(10),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: loadedProduct.id,
                        child: Image.network(
                          loadedProduct.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'R\$${loadedProduct.price}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: TextButton.icon(
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Theme.of(context).primaryColor,
                            ),
                            label: Text('Add to Cart'),
                            onPressed: () {
                              Provider.of<Cart>(context, listen: false).addItem(
                                  loadedProduct.id,
                                  loadedProduct.price,
                                  loadedProduct.title);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Text(
                        loadedProduct.description,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 1000,
              )
            ]),
          ),
        ],
        // child: Container(
        //   color: Colors.grey,
        //   child: Column(
        //     children: [
        //       //Spacer(),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
