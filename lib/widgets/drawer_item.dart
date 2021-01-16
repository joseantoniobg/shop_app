import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String caption;
  final String routeName;

  DrawerItem(this.icon, this.caption, this.routeName);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(caption),
      onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
    );
  }
}
