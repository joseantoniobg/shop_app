import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/loading_overlay.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  // Future _ordersFuture;

  // Future obtainOrdersFuture() {
  //   return Provider.of<Orders>(context, listen: false).fetchOrdersFromServer();
  // }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchOrdersFromServer();
      _isLoading = false;
      if (this.mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: [
          !orderData.hasOrders() && !_isLoading
              ? Center(
                  child: Text(
                    'No orders avalaible yet!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(
                    orderData.orders[i],
                  ),
                  itemCount: orderData.orders.length,
                ),
          // FutureBuilder(
          //   future: Provider.of<Orders>(context, listen: false)
          //       .fetchOrdersFromServer(),
          //   builder: (ctx, dataSnapshot) {
          //     if (dataSnapshot.connectionState == ConnectionState.waiting) {
          //       return LoadingOverlay('Loading your Orders...');
          //     } else {
          //       return SizedBox();
          //     }
          //   },
          // ),
          _isLoading ? LoadingOverlay('Loading your Orders...') : SizedBox(),
        ],
      ),
    );
  }
}
