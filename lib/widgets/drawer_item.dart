import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import '../helpers/custom_route.dart';

enum ActionType { pushReplacement, push, pushCustom }

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String caption;
  final String routeName;
  final ActionType action;

  DrawerItem(this.icon, this.caption, this.routeName, this.action);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(caption),
      onTap: () => action == ActionType.pushReplacement
          ? Navigator.of(context).pushReplacementNamed(routeName)
          : action == ActionType.push
              ? Navigator.of(context).pushNamed(routeName)
              : Navigator.of(context).pushReplacement(CustomRoute(
                  builder: (ctx) => OrdersScreen(),
                )),
    );
  }
}
