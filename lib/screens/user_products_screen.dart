import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/loading_overlay.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: '');
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? LoadingOverlay('Loading list of products')
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, productData, _) => productData.items.length ==
                          0
                      ? Center(
                          child: Text('No products has been added by you yet'),
                        )
                      : Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemBuilder: (_, i) => Column(
                              children: [
                                Divider(),
                                UserProductItem(
                                  productData.items[i].id,
                                  productData.items[i].title,
                                  productData.items[i].imageUrl,
                                ),
                              ],
                            ),
                            itemCount: productData.items.length,
                          ),
                        ),
                ),
              ),
      ),
    );
  }
}
