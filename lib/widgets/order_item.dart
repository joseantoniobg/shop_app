import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? widget.order.products.length * 40.0 + 95 : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('R\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              height: _expanded ? widget.order.products.length * 40.0 : 0,
              child: ListView.builder(
                itemBuilder: (ctx, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.products[i].title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.order.products[i].quantity} x ${widget.order.products[i].price}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                itemCount: widget.order.products.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
