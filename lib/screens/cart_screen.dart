import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Your Cart Items'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  _isLoading
                      ? Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Container(
                            width: 40,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : FlatButton(
                          onPressed: cart.getItemsCount == 0 || _isLoading
                              ? null
                              : () async {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await Provider.of<Orders>(context,
                                            listen: false)
                                        .addOrder(
                                      cart.items.values.toList(),
                                      cart.totalAmount,
                                    );
                                    cart.clear();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    _scaffoldKey.currentState
                                        .hideCurrentSnackBar();
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Order successfully placed!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  } catch (error) {
                                    _scaffoldKey.currentState
                                        .hideCurrentSnackBar();
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'An error occured!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            'ORDER NOW!',
                            style: TextStyle(
                                color: cart.getItemsCount == 0
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor),
                          ),
                        ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItemWidget(
                id: cart.items.values.toList()[index].id,
                title: cart.items.values.toList()[index].title,
                quantity: cart.items.values.toList()[index].quantity,
                price: cart.items.values.toList()[index].price,
                productId: cart.items.keys.toList()[index],
              ),
              itemCount: cart.getItemsCount,
            ),
          ),
        ],
      ),
    );
  }
}
