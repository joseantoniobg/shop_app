import 'package:flutter/material.dart';

enum ActionType { pushReplacement, push }

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
          : Navigator.of(context).pushNamed(routeName),
    );
  }
}
