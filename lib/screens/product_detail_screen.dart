import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routName = '/product-detail';

  ProductDetailScreen();
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
