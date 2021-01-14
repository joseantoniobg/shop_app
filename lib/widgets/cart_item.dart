import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItemWidget({this.id, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: FittedBox(
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Text('R\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: R\$ ${(price * quantity)}'),
            trailing: Text('$quantity x R\$ $price'),
          ),
        ),
      ),
    );
  }
}
