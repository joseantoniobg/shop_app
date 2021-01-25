import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/products.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart' show Cart;

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  //var _isInit = true;
  var _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) =>
        Provider.of<Products>(context, listen: false)
            .fetchAndSetProducts()
            .then((_) {
          _isLoading = false;
          if (this.mounted) {
            setState(() {});
          }
        }));
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     _isLoading = true;
  //     setState(() {});
  //     Provider.of<Products>(context).fetchAndSetProducts().then((_) {
  //       _isLoading = false;
  //       setState(() {});
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    //final productsContainer = Provider.of<Products>(context, listen: false);
    //final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop Products'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.getItemsCount.toString(),
              color: Colors.red,
              topPosition: 30,
              rightPosition: 7,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Log Out'),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Provider.of<Auth>(ctx, listen: false).logOut();
                              Navigator.of(ctx).pushReplacementNamed('/');
                            },
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(ctx).pop(),
                          )
                        ],
                      ));
            },
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Stack(children: [
        ProductsGrid(_showOnlyFavorites),
        if (_isLoading) LoadingOverlay('Loading Products...')
      ]),
    );
  }
}
