import 'package:flutter/material.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../widgets/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          DrawerItem(
              Icons.credit_card, 'Shop', '/', ActionType.pushReplacement),
          DrawerItem(Icons.payment, 'Orders', OrdersScreen.routeName,
              ActionType.pushCustom),
          DrawerItem(Icons.shopping_bag, 'Manage Products',
              UserProductsScreen.routeName, ActionType.pushReplacement),
        ],
      ),
    );
  }
}
